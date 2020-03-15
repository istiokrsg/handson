#!/bin/bash

SHELL_DIR=$(dirname $0)

NAME="istio"
NAMESPACE="istio-system"
VERSION=1.5.0

ISTIO_DIR="${SHELL_DIR}/../downloads/istio"
ISTIO_HOME="${ISTIO_DIR}/istio-${VERSION}"