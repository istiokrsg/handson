#!/bin/bash
SHELL_DIR=$(dirname $0)

source "../0-common/common.sh"


### virtualservice setting
FILE_V_SVC="${ISTIO_HOME}/samples/bookinfo/networking/virtual-service-all-v1.yaml"

if [ -f ${FILE_V_SVC} ]; then
  echo "CMD : kubectl apply -f ${FILE_V_SVC}"
  kubectl apply -f ${FILE_V_SVC}
fi



### destinationrule setting
FILE_D_RULE="${ISTIO_HOME}/samples/bookinfo/networking/destination-rule-all.yaml"
if [ -f ${FILE_D_RULE} ]; then
  echo "CMD : kubectl apply -f ${FILE_D_RULE}"
  kubectl apply -f ${FILE_D_RULE}
fi


