ADT_HOME=~/local/adt
export PATH=${ADT_HOME}/sdk/tools:${ADT_HOME}/sdk/platform-tools:${PATH}

alias adt='env http_proxy= ${ADT_HOME}/eclipse/eclipse 2> /dev/null > /dev/null'