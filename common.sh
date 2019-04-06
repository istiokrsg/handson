#!/bin/bash

OS_NAME="$(uname | awk '{print tolower($0)}')"

L_PAD="  "

command -v fzf > /dev/null && FZF=true
command -v tput > /dev/null && TPUT=true

_echo() {
    if [ "${TPUT}" != "" ] && [ "$2" != "" ]; then
        echo -e "${L_PAD}$(tput setaf $2)$1$(tput sgr0)"
    else
        echo -e "${L_PAD}$1"
    fi
}

_read() {
    echo
    if [ "${3}" == "S" ]; then
        if [ "${TPUT}" != "" ] && [ "$2" != "" ]; then
            read -s -p "${L_PAD}$(tput setaf $2)$1$(tput sgr0)" ANSWER
        else
            read -s -p "${L_PAD}$1" ANSWER
        fi
    else
        if [ "${TPUT}" != "" ] && [ "$2" != "" ]; then
            read -p "${L_PAD}$(tput setaf $2)$1$(tput sgr0)" ANSWER
        else
            read -p "${L_PAD}$1" ANSWER
        fi
    fi
}

_result() {
    echo
    _echo "# $@" 4
}

_success() {
    echo
    _echo "+ $@" 2
    _exit 0
}

_error() {
    echo
    _echo "- $@" 1
    _exit 1
}

_exit() {
    echo
    exit $1
}

select_one() {
    SELECTED=

    CNT=$(cat ${LIST} | wc -l | xargs)
    if [ "x${CNT}" == "x0" ]; then
        return
    fi

    echo

    IDX=0
    while read VAL; do
        IDX=$(( ${IDX} + 1 ))
        printf "%3s. %s\n" "${IDX}" "${VAL}"
    done < ${LIST}

    if [ "${CNT}" != "1" ]; then
        CNT="1-${CNT}"
    fi

    _read "Please select one. (${CNT}) : " 6

    if [ -z ${ANSWER} ]; then
        return
    fi
    TEST='^[0-9]+$'
    if ! [[ ${ANSWER} =~ ${TEST} ]]; then
        return
    fi
    SELECTED=$(sed -n ${ANSWER}p ${LIST})

}

question() {
    _read "${1:-"Enter your choice : "}" 6

    if [ ! -z ${2} ]; then
        if ! [[ ${ANSWER} =~ ${2} ]]; then
            ANSWER=
        fi
    fi
}