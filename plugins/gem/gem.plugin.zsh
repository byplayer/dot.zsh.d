# add brew completion function to path
fpath=($ZSH_EXT_BASE/plugins/gem $fpath)
autoload -U compinit
compinit -i
