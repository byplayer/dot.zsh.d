# This is plugin to open vscode with ssh
#
# refer:
#   - https://qiita.com/miyanaga/items/968b857d9b88c1c61960
#   - https://www.kerislab.jp/posts/2021-01-16-sshcode/

function sshcode() {
  # variables to use
  local port destination host dir
  # parse option
  local -A opthash
  zparseopts -D -E -A opthash -- p:
  port=${opthash[-p]}
  # check argument
  if [ $# -eq 0 ]; then
    echo "usage: $0 [-p port] host[:path]"
    return -1
  fi
  # find host and dir
  destination="$1"
  host="${destination%%:*}" # before ':'
  dir="${destination##*:}"  # after ':'
  # fix dir if ':' does not exist
  [ "$host" = "$dir" ] && dir=""
  # find abs path if $dir does not start with '/'
  [ "${dir:0:1}" != "/" ] && dir="$(ssh ${port:+-p $port} $host pwd)/$dir"
  # open with code
  code --folder-uri "vscode-remote://ssh-remote+$host${port:+:$port}$dir"
}

function _sshcode_completion () {
  # ref: /usr/share/zsh/functions/Completion/Unix/_ssh
  local expl suf ret=1
  typeset -A opt_args
  if compset -P 1 '[^./][^/]#:'; then
    _remote_files -- ssh ${(kv)~opt_args[(I)-[FP1246]]/-P/-p} && ret=0
  elif compset -P 1 '*@'; then
    suf=( -S '' )
    compset -S ':*' || suf=( -r: -S: )
    _wanted hosts expl 'remote host name' _ssh_hosts $suf && ret=0
  else
    _alternative 'hosts:remote host name:_ssh_hosts -r: -S:'
  fi
  return ret
}

compdef _sshcode_completion sshcode
