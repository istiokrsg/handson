#!/bin/bash
SHELL_DIR=$(dirname $0)

source "../0-common/common.sh"

### namespace labeling
kubectl label namespace default istio-injection=enabled > /dev/null 2>&1


### install sample app
kubectl apply -f ${ISTIO_HOME}/samples/bookinfo/platform/kube/bookinfo.yaml

#### check
# kubectl exec -it $(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}') -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"

kubectl apply -f ${ISTIO_HOME}/samples/bookinfo/networking/bookinfo-gateway.yaml

## get URL
INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ "" == "${INGRESS_HOST}" ]; then
  INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
fi
INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

echo ""
echo "GATEWAY_URL=${GATEWAY_URL}"

#### check
#http://localhost/productpage
echo "Check bookinfo app"
curl -s http://${GATEWAY_URL}/productpage | grep -o "<title>.*</title>"
echo ""


