if [ -f $HOME/.jdk_default.sh ]; then
  source $HOME/.jdk_default.sh
fi

[[ -s "$HOME/.gvm/bin/gvm-init.sh" ]] && source "$HOME/.gvm/bin/gvm-init.sh"

# fix problem for zaw-src-cdr
unsetopt sh_word_split