export ZSH_EXT_BASE=$HOME/.zsh.d

# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH_EXT_BASE/lib/*.zsh) source $config_file
