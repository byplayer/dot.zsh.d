export MEMO_BASE_DIR=~/docs/org_doc
export MEMO_EDITOR=code

function make_memo () {
    MEMO_BASE_NAME=$1

    if [ ! -d ${MEMO_BASE_DIR}/docs/`date +%Y` ] ; then
        mkdir ${MEMO_BASE_DIR}/docs/`date +%Y`
    fi

    MEMO_PATH=${MEMO_BASE_DIR}/docs/`date +%Y`/`date +%Y%m%d`_${MEMO_BASE_NAME}.md
    echo "create and open ${MEMO_PATH}"
    ${MEMO_EDITOR} $MEMO_PATH
}
