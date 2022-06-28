type brew > /dev/null
if [ $? -eq 0 ]; then
    source $(brew --prefix asdf)/libexec/asdf.sh
    fpath=(/opt/homebrew/opt/asdf/share/zsh/site-functions $fpath)
fi
