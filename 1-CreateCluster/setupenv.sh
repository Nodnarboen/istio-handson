#!/bin/bash

    echo ""
    
    echo "Creating GKE Cluster..."

    export USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" | awk -F"@" '{print $1}' | sed 's/\./-/g')
    export CLUSTER="APACbootcamp-istio"
    export CLUSTER_NAME=${USER}-${CLUSTER}

    export RAND=$(( $RANDOM % 3 + 1 ))

    case $RAND in
        1)
        export ZONE="asia-southeast1-a"
        ;;
        2)
        export ZONE="asia-southeast2-b"
        ;;
        3)
        export ZONE="australia-southeast1-a"
        ;;
    esac

    gcloud services enable container.googleapis.com

    gcloud container clusters create $CLUSTER_NAME --zone=$ZONE --num-nodes=2 --machine-type=n1-highmem-2 --image-type=Ubuntu

    kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)

echo "Cluster created"

