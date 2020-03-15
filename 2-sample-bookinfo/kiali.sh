#!/bin/bash
SHELL_DIR=$(dirname $0)

source "../0-common/common.sh"

echo "Run Kiali"
echo "Default login ID/PW is [admin/admin]"

echo "${ISTIO_HOME}/bin/istioctl dashboard kiali"
${ISTIO_HOME}/bin/istioctl dashboard kiali


