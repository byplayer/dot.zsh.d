if [ -f $HOME/.jdk_default.sh ]; then
  source $HOME/.jdk_default.sh
fi

export SDKMAN_DIR="$HOME/.sdkman"
[[ -f "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# fix problem for zaw-src-cdr
unsetopt sh_word_split

export PATH=$PATH:/opt/google-java-format/bin
