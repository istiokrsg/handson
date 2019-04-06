#!/bin/bash

SHELL_DIR=$(dirname $0)

TEMP_DIR=${SHELL_DIR}/temp

# util func
source ${SHELL_DIR}/common.sh

prepare() {
    mkdir -p ${TEMP_DIR}
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

    main_menu
}

main_menu() {

    echo
    _echo "1. istio install"
    echo
    _echo "9. istio delete"
    echo
    _echo "x. exit"

    question

    case ${ANSWER} in
        1)
            istio_install
            main_menu
            ;;
        9)
            istio_delete
            main_menu
            ;;
        x)
            _success "Good bye!"
            ;;
        *)
            main_menu
            ;;
    esac

}

istio_install() {
    _echo "istio install"

}

istio_delete() {
    _echo "istio delete"
}

run
