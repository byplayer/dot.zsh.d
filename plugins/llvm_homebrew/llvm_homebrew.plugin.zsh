case ${OSTYPE} in
darwin*)
    export PATH=${HOMEBREW_PREFIX}/opt/llvm/bin:$PATH
    ;;
esac
