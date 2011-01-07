# プロンプトのカラー表示を有効
autoload -U colors
colors

eval `dircolors ~/.dir_colors -b`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

