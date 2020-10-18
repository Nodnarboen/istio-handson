#!/bin/bash

kubectl apply -f ../utils/sampleapp/ingress/istioGatewayRules.yaml

if hash gcloud 2>/dev/null; then
    echo "Google Cloud"
    export PROVIDER=GKE
    export INGRESS_URL=$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')
elif hash microk8s 2>/dev/null; then
    echo "Microk8s"
    export PROVIDER=Microk8s
    export PUBLIC_IP=$(curl -s ifconfig.me) 
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
    export INGRESS_URL=$DOMAIN:$INGRESS_PORT
else
    echo "No supported Provider (GCP or Microk8s) detected."
    exit 1;
fi

echo "----------------------------------------------------"
echo "Gateway is running at : http://$INGRESS_URL"
echo "----------------------------------------------------"
