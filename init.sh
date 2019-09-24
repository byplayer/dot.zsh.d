export ZSH_EXT_BASE=$HOME/.zsh.d

# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH_EXT_BASE/lib/*.zsh) source $config_file

# load plugins
for plugin ($ZSH_EXT_BASE/plugins/*) {
  plugin_name=`basename $plugin`
  if [ -f $ZSH_EXT_BASE/plugins/$plugin_name/$plugin_name.plugin.zsh ]; then
    source $ZSH_EXT_BASE/plugins/$plugin_name/$plugin_name.plugin.zsh
  fi
}

# add local_tools at the top of PATH
export PATH=/opt/local_tools:$PATH

autoload -U compinit
compinit -i

