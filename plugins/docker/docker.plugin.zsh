# docker
alias d="docker"

# drma() { docker rm $(docker ps -a -q); }
alias dpa="docker ps -a"
alias dps="docker ps"
alias di="docker images"
alias dc="docker-compose"

dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort;}