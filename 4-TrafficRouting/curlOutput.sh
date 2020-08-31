#!/bin/bash

export APP_URL=$(kubectl describe svc fleetman-webapp -n default | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

while true;
do
    curl -s http://$APP_URL/api/vehicles/driver/City%20Truck -w "\n"

    sleep 0.5
done