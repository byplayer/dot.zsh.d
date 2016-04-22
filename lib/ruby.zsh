#rbenv
if [ -d /opt/rbenv ]; then
  export RBENV_ROOT=/opt/rbenv
fi
export PATH=${RBENV_ROOT}/bin:$PATH
eval "$(rbenv init -)"

export PATH=$HOME/.ruby_tool/vendor/bin:$PATH

# ruby aliases
alias r="rails"
alias be="bundle exec"
alias berails="bundle exec rails"
alias berake="bundle exec rake"

