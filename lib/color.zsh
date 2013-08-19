# プロンプトのカラー表示を有効
autoload -U colors
colors

case ${OSTYPE} in
  darwin*)
    eval `gdircolors ~/.dir_colors -b`
    ;;
  *)
    eval `dircolors ~/.dir_colors -b`
    ;;
esac

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

