export PATH=$HOME/.python_tool/bin:$PATH
if [ -d $HOME/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH=$HOME/.pyenv/bin:$PATH
fi

eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
