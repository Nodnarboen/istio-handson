#!/bin/bash

export INGRESS_URL=$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

while true;
do
    curl -s http://$INGRESS_URL | grep title

    sleep 0.5
done
