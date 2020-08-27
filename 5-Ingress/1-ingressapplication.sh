#!/bin/bash

kubectl apply -f ../utils/sampleapp/ingress/application-no-istio.yaml

echo "Waiting for Application to start..."
sleep 120

export APP_URL=$(kubectl describe svc fleetman-webapp -n default | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

echo "----------------------------------------------------"
echo "Application is running at : http://$APP_URL"
echo "----------------------------------------------------"