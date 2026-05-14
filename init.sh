export ZSH_EXT_BASE=$HOME/.zsh.d

# Defer compdef calls made during lib/plugin loading until after compinit.
# Plugins may both add to $fpath and call compdef; this stub lets compinit
# run last (after every fpath addition) regardless of load order.
typeset -ga _pending_compdefs
compdef() { _pending_compdefs+=("${(j: :)${(q)@}}") }

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

if [ -d $HOME/.local/bin ]; then
  export PATH=$HOME/.local/bin:$PATH
fi

if [ -d $HOME/.local/share/zsh/site-functions ]; then
  fpath=($HOME/.local/share/zsh/site-functions $fpath)
fi

# run compinit after all fpath additions (lib, plugins, local site-functions),
# then replay the compdef calls collected by the stub above.
unfunction compdef
autoload -U compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -i
else
  compinit -C -i
fi
for _cd in $_pending_compdefs; do eval "compdef $_cd"; done
unset _pending_compdefs _cd

# lib_after_plugin: loaded last, after compinit and all widget setup
for config_file ($ZSH_EXT_BASE/lib_after_plugin/*.zsh) source $config_file
