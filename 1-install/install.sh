#!/bin/bash

SHELL_DIR=$(dirname $0)

source "../0-common/common.sh"

VALUES="${ISTIO_HOME}/install/kubernetes/helm/istio/values-istio-demo.yaml"

if [ ! -d ${ISTIO_HOME} ]; then
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${VERSION} sh -

    mkdir -p ${ISTIO_DIR}
    mv istio-${VERSION} ${ISTIO_HOME}
fi


## helm init
kubectl create sa tiller -n kube-system > /dev/null 2>&1
kubectl create clusterrolebinding cluster-admin:kube-system:tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller > /dev/null 2>&1
helm init --upgrade --service-account=tiller

## istio init
kubectl create ns ${NAMESPACE} > /dev/null 2>&1
helm template ${ISTIO_HOME}/install/kubernetes/helm/istio-init --name istio-init --namespace ${NAMESPACE} | kubectl apply -f -


# istio install
helm upgrade --install ${NAME} ${ISTIO_HOME}/install/kubernetes/helm/istio --namespace ${NAMESPACE} --values ${VALUES}

