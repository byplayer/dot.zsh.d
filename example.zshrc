# .zshrc
export PATH=/usr/local/bin:$PATH
if [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

source ${HOME}/.zsh.d/init.sh

# load local configurations
if [ -f "${HOME}/.zsh_local" ]; then
  source "${HOME}/.zsh_local"
fi
