type brew >/dev/null
if [ $? -eq 0 ]; then
    export PATH="$(brew --prefix asdf)/bin:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi
