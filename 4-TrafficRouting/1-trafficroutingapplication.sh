#!/bin/bash

kubectl apply -f ../utils/sampleapp/trafficrouting/application-no-istio.yaml

#Create ClusterRoleBinding View to pull labels and annotations for default namespace
kubectl -n default create rolebinding default-view --clusterrole=view --serviceaccount=default:default

echo "Waiting for Application to start..."
sleep 120


export APP_URL=$(kubectl describe svc fleetman-webapp -n default | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

echo "----------------------------------------------------"
echo "Application is running at : http://$APP_URL"
echo "----------------------------------------------------"