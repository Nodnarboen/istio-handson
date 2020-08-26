#!/bin/bash

kubectl apply -f ../utils/sampleapp/application-no-istio.yaml

#Create ClusterRoleBinding View to pull labels and annotations for default namespace
kubectl -n default create rolebinding default-view --clusterrole=view --serviceaccount=default:default