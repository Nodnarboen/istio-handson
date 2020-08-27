#!/bin/bash

export APP_URL=$(kubectl describe svc fleetman-webapp -n default | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

while true;
do
    curl -s http://$APP_URL | grep title

    sleep 0.5
done