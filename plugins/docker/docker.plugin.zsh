# docker
alias d="docker"

drma() { docker rm $(docker ps -a -q); }
alias dpa="docker ps -a"
alias dps="docker ps"
alias di="docker images"
dbu() {docker build -t=$1 .;}