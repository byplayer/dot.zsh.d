type brew > /dev/null
if [ $? -eq 0 ]; then
    source $(brew --prefix asdf)/libexec/asdf.sh
fi
