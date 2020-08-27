#!/bin/bash

kubectl apply -f ../utils/sampleapp/darkreleases/istioDarkRelease.yaml

export INGRESS_URL=$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

echo "----------------------------------------------------"
echo "Gateway is running at : http://$INGRESS_URL"
echo "----------------------------------------------------"