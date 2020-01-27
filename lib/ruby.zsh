#rbenv
if [ -d /opt/rbenv ]; then
  export RBENV_ROOT=/opt/rbenv
  export PATH=${RBENV_ROOT}/bin:$PATH
fi
eval "$(rbenv init -)"

export PATH=$PATH:$HOME/.ruby_tool/vendor/bin

# ruby aliases
alias r="rails"
alias be="bundle exec"
alias berails="bundle exec rails"
alias berake="bundle exec rake"

