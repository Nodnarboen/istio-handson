#!/bin/bash

kubectl apply -f ../utils/istio/istio-init.yaml
kubectl apply -f ../utils/istio/istio-deploy.yaml

echo "Waiting for Istio to start..."

sleep 120

if hash gcloud 2>/dev/null; then
    echo "Google Cloud"
    export PROVIDER=GKE
    export KIALI_URL=$(kubectl describe svc kiali -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')
elif hash microk8s 2>/dev/null; then
    echo "Microk8s"
    export PROVIDER=Microk8s
    export PUBLIC_IP=$(curl -s ifconfig.me) 
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    export KIALI_PORT=$(kubectl describe svc kiali -n istio-system | grep "NodePort:" | sed 's/[^0-9]*//g')
    export KIALI_URL=$DOMAIN:$KIALI_PORT
else
    echo "No supported Provider (GCP or AKS or Microk8s) detected."
    exit 1;
fi

echo "----------------------------------------------------"
echo "Kiali is running at : http://$KIALI_URL"
echo "Username is : admin"
echo "Password is : admin"
echo "----------------------------------------------------"
