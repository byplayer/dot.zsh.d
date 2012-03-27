# .zshrc

source $HOME/.zsh.d/init.sh

# load local configurations
if [ -f ~/.zsh_local ]; then
  . ~/.zsh_local
fi

