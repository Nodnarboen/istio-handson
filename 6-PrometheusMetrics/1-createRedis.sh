#!/bin/bash

kubectl create namespace prometheus-playground
kubectl apply -f redis-master-deployment.yaml
kubectl get pods -n prometheus-playground


