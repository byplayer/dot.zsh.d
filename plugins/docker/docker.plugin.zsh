# docker
alias d="docker"
alias dc="docker-compose"

docker() {
  case $1 in
  i.l.a)
    shift
    command docker image ls --all "$@"
    ;;
  i.l)
    shift
    command docker image ls "$@"
    ;;
  i.p)
    shift
    command docker image prune "$@"
    ;;
  i.r)
    shift
    command docker image rm "$@"
    ;;
  i)
    shift
    command docker image "$@"
    ;;
  c.l.a)
    shift
    command docker container ls --all "$@"
    ;;
  c.l)
    shift
    command docker container ls "$@"
    ;;
  c.p)
    shift
    command docker container prune "$@"
    ;;
  c.r)
    shift
    command docker container rm "$@"
    ;;
  c)
    shift
    command docker container "$@"
    ;;
  v)
    shift
    command docker volume "$@"
    ;;
  v.l)
    shift
    command docker volume ls "$@"
    ;;
  *)
    command docker "$@"
    ;;
  esac
}

dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/" | sed "s/['|\']//g" | sort; }
