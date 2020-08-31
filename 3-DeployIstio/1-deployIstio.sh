#!/bin/bash

kubectl apply -f ../utils/istio/istio-init.yaml
kubectl apply -f ../utils/istio/istio-deploy.yaml

echo "Waiting for Istio to start..."

sleep 120

export KIALI_URL=$(kubectl describe svc kiali -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

echo "----------------------------------------------------"
echo "Kiali is running at : http://$KIALI_URL"
echo "Username is : admin"
echo "Password is : admin"
echo "----------------------------------------------------"