#!/bin/bash

kubectl apply -f ../utils/sampleapp/trafficrouting/application-no-istio.yaml

#Create ClusterRoleBinding View to pull labels and annotations for default namespace
kubectl -n default create rolebinding default-view --clusterrole=view --serviceaccount=default:default

echo "Waiting for Application to start..."
sleep 120

if hash gcloud 2>/dev/null; then
    echo "Google Cloud"
    export PROVIDER=GKE
    export APP_URL=$(kubectl describe svc fleetman-webapp -n default | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')
elif hash microk8s 2>/dev/null; then
    echo "Microk8s"
    export PROVIDER=Microk8s
    export PUBLIC_IP=$(curl -s ifconfig.me) 
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    export APP_PORT=$(kubectl describe svc fleetman-webapp -n default | grep "NodePort:" | sed 's/[^0-9]*//g')
    export APP_URL=$DOMAIN:$APP_PORT
else
    echo "No supported Provider (GCP or AKS or Microk8s) detected."
    exit 1;

echo "----------------------------------------------------"
echo "Application is running at : http://$APP_URL"
echo "----------------------------------------------------"
