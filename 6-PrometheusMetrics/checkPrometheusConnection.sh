#!/bin/bash

export APISERVER=`kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'`
export TOKEN=`kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.token}' -n dynatrace | base64 --decode`

curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure

