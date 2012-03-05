# ruby environment
RUBY_HOME=/usr/local/ruby

export PATH=${RUBY_HOME}/bin:$PATH
export MANPATH=${RUBY_HOME}/share/man:`manpath -q`

alias rbctags="ctags --regex-ruby='/^[ \t]*([A-Z_][A-Z0-9_]*)[ \t]*=/\1/C,constant/'"

# rails env
alias r="rails"
alias be="bundle exec"
alias berails="bundle exec rails"
alias berails="bundle exec rake"