#!/bin/bash

export APISERVER=`kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'`
export TOKEN=`kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.token}' -n dynatrace | base64 --decode`

#curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure

PODNAME=`kubectl get pods -n prometheus-playground|awk '$1 ~ /redis-master/ {print $1}'|head -1`
NAMESPACE="prometheus-playground"
PORT="9121"

curl -X GET $APISERVER/api/v1/namespaces/$NAMESPACE/pods/$PODNAME:$PORT/proxy/metrics \
  --header "authorization: Bearer $TOKEN" \
  --insecure

