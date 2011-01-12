# rvm
if [[ -s $HOME/.rvm/scripts/rvm ]] ;
then
  source $HOME/.rvm/scripts/rvm ;
fi

fpath=($HOME/.rvm/scripts/zsh/Completion $fpath)
