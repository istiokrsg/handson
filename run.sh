#!/bin/bash

SHELL_DIR=$(dirname $0)

TEMP_DIR=${SHELL_DIR}/temp

prepare() {
		mkdir -p ${TEMP_DIR}
}

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

_error() {
    echo
    _echo "- $@" 1
    _exit 1
}

select_one() {
    OPT=$1

    SELECTED=

    CNT=$(cat ${LIST} | wc -l | xargs)
    if [ "x${CNT}" == "x0" ]; then
        return
    fi

    if [ "${OPT}" != "" ] && [ "x${CNT}" == "x1" ]; then
        SELECTED="$(cat ${LIST} | xargs)"
    else
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
    fi
}

get_cluster() {

		LIST=${TEMP_DIR}/cluster-list
    kubectl config view -o json | jq -r '.contexts[].name' | sort > ${LIST}

    select_one true

    if [ "${SELECTED}" == "" ]; then
        _error
    fi

		CLUSTER_NAME="${SELECTED}"

		kubectl config use ${CLUSTER_NAME}
}

run() {
		prepare

		get_cluster
}


run
