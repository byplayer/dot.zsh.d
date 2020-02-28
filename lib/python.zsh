export PATH=$HOME/.python_tool/bin:$PATH
if [ -d $HOME/.pyenv ]; then
  export PATH=$HOME/.pyenv/bin:$PATH
fi
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
