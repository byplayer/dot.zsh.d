# docker
alias d="docker"

alias dcl="docker container ls"
alias dcla="docker container ls -a"
alias dil="docker image ls"
alias dip="docker image prune"
alias dc="docker-compose"

dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort;}