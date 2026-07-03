autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default true

# cdr の履歴ファイルとロックファイル。意図的なグローバルであることを typeset -g で
# 明示する（readonly は付けない: 設定を再ソースすると read-only エラーになるため）。
#
# 履歴ファイルのパスは cdr 本体（chpwd_recent_filehandler）と同じ手順で解決する:
# recent-dirs-file style があればそれを使い（"+" はデフォルトに展開）、無ければ
# ${ZDOTDIR:-$HOME}/.chpwd-recent-dirs を使う。書き込み先は先頭要素 files[1]。
# style はここで評価するので、recent-dirs-file を使う場合は上の zstyle 群と
# 一緒に（この行より前で）設定すること。
typeset -g __CDR_FILE
() {
  emulate -L zsh
  setopt extended_glob
  local default=${ZDOTDIR:-$HOME}/.chpwd-recent-dirs
  local -a files
  zstyle -a ':chpwd:' recent-dirs-file files && files=(${files//(#s)+(#e)/$default})
  (( ${#files} )) || files=($default)
  __CDR_FILE=${files[1]}
}
typeset -g __CDR_LOCK="${__CDR_FILE}.lock"
# ロックファイルが作成からこの秒数以上経過していたら、異常終了などで残った
# stale なロックとみなす（30 分）。ロックファイルには一切書き込まないため
# mtime = 作成日時のままなので、mtime の経過時間で判定できる。
typeset -gi __CDR_LOCK_STALE_SEC=1800
# ロック取得に成功した fd を入れるグローバル（__cdr_flock がセットする）。
typeset -g __cdr_fd=''

# zsystem flock -f <var> <file> はファイルを O_CREAT では開かない（無いと失敗する）
# ため、あらかじめ空のロックファイルを用意しておく。
# 作成に使う「: >> file」はコマンド終了時に fd を閉じるので、exec による
# オープンと違い fd をリークしない。
[[ -e $__CDR_LOCK ]] || : >> "$__CDR_LOCK" 2>/dev/null

# ロックを取得し、成功したらグローバル __cdr_fd に fd をセットして 0 を返す。
# timeout 秒だけ待つ。-i 0.01 で 10ms 間隔でポーリングする
# （-i 省略時は既定 1 秒間隔になり、多重競合時に取りこぼしてタイムアウトする）。
# ロックファイルが stale 削除などで消えていれば作り直す。
__cdr_flock() {
  __cdr_fd=''
  [[ -e $__CDR_LOCK ]] || : >> "$__CDR_LOCK" 2>/dev/null
  zsystem flock -t "$1" -i 0.01 -f __cdr_fd "$__CDR_LOCK" 2>/dev/null
}

# cd 時の履歴書き込み（chpwd_recent_dirs）をロックで直列化するラッパー。
#
# chpwd_recent_dirs は read-modify-write を「> file」で非アトミックかつ
# 無ロックに行うため、prepare-tmux のように複数シェルが同時に cd すると
# 上書き競合で履歴が失われる（実測: 25 シェル同時で数件ロスト）。
# 読み込み〜書き込みの全体を flock で囲むことで欠損をなくす。
__cdr_chpwd() {
  emulate -L zsh
  zmodload -F zsh/system b:zsystem 2>/dev/null || { chpwd_recent_dirs; return }

  # 通常はここで取得できる（最大 5 秒待つ）。
  if ! __cdr_flock 5; then
    # 取得できない = 誰かが保持中。ただしロックファイルが作成から 30 分以上
    # 経過していれば、異常終了/ハングで放置された持ち主とみなして削除し、
    # 作り直して取り直す。正常な保持はミリ秒で解放されるのでここには来ない。
    if [[ -n ${__CDR_LOCK}(Nms+${__CDR_LOCK_STALE_SEC}) ]]; then
      rm -f -- "$__CDR_LOCK"
      __cdr_flock 5
    fi
  fi

  if [[ -n $__cdr_fd ]]; then
    # try/always: どの経路で抜けても必ず fd を閉じてロックを解放する。
    { chpwd_recent_dirs } always { exec {__cdr_fd}>&- }
  else
    # それでも取れなければ従来どおり書く（デッドロックだけは避ける）。
    chpwd_recent_dirs
  fi
}
add-zsh-hook chpwd __cdr_chpwd

# cdr 履歴ファイルから存在しないディレクトリを取り除く。
# 上と同じロックを共有し、tmp への書き出し + 原子的 rename で置換するので、
# 複数シェル同時起動でも上書き競合・履歴消失は起きない。
__cdr_prune_recent_dirs() {
  emulate -L zsh
  setopt no_nomatch no_unset

  [[ -r $__CDR_FILE ]] || return 0
  zmodload -F zsh/system b:zsystem 2>/dev/null || return 0

  # cd 書き込みや他の prune が走っていれば（非ブロッキングで取得失敗）何もしない。
  # prune は取りこぼしても次回また走るので待つ必要はない。
  __cdr_flock 0 || return 0

  local tmp="${__CDR_FILE}.tmp.$$"
  local line dir
  local -a parts
  # try/always: 途中で return・エラー・シグナルのいずれで抜けても
  # 必ず fd を閉じて（＝ロック解放）tmp を後始末する。
  {
    : > "$tmp" || return 0
    while IFS= read -r line; do
      [[ -n $line ]] || continue
      # 各行は $'...' 形式。cdr 本体（chpwd_recent_filehandler）と同じく
      # (z) で分割し (Q) で引用符を外して実パスへ復号する（eval は使わない）。
      parts=(${(z)line})
      dir=${(Q)${parts[1]:-}}
      [[ -d $dir ]] && print -r -- "$line" >> "$tmp"
    done < "$__CDR_FILE"
    mv -f "$tmp" "$__CDR_FILE" 2>/dev/null
  } always {
    [[ -e $tmp ]] && rm -f "$tmp"
    exec {__cdr_fd}>&-
  }
}

# cd のたびに実行する必要はないので、確率的に（およそ 1/200）
# バックグラウンドで起動する。&! でジョブを切り離し、
# プロンプト表示をブロックしない。
__cdr_prune_recent_dirs_maybe() {
  (( RANDOM % 200 == 0 )) || return 0
  __cdr_prune_recent_dirs &!
}
add-zsh-hook chpwd __cdr_prune_recent_dirs_maybe
