#!/bin/bash

kubectl apply -f ../utils/sampleapp/ingress/istioGatewayRules.yaml

export INGRESS_URL=$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'

echo "----------------------------------------------------"
echo "Gateway is running at : http://$INGRESS_URL"
echo "----------------------------------------------------"
