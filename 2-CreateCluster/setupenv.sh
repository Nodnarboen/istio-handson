#!/bin/bash

export API_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceApiToken')
export PAAS_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatracePaaSToken')
export TENANTID=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceTenantID')
export ENVIRONMENTID=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceEnvironmentID')

if hash gcloud 2>/dev/null; then
    echo "Google Cloud"
    export CLOUD_PROVIDER=GKE
elif hash az 2>/dev/null; then
    echo "Azure Cloud"
    export CLOUD_PROVIDER=AKS
else
    echo "No supported Cloud Provider (GCP or AKS) detected."
    exit 1;
fi

echo "Creating $CLOUD_PROVIDER Cluster with the following credentials: "
echo "API_TOKEN = $API_TOKEN"
echo "PAAS_TOKEN = $PAAS_TOKEN"
echo "TENANTID = $TENANTID"
echo "ENVIRONMENTID = $ENVIRONMENTID"
echo "Cloud Provider = $CLOUD_PROVIDER"

echo ""
read -p "Is this all correct? (y/n) : " -n 1 -r
echo ""

usage()
{
    echo 'Usage : ./setupenv.sh API_TOKEN PAAS_TOKEN TENANTID ENVIRONMENTID (optional if a SaaS deployment)'
    exit
}

deployGKE()
{
    echo ""
    
    echo "Creating GKE Cluster..."

    export USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" | awk -F"@" '{print $1}' | sed 's/\./-/g')
    export CLUSTER="sebootcamp-istio"
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
}

if [[ $REPLY =~ ^[Yy]$ ]]; then
    case $CLOUD_PROVIDER in
        GKE)
        deployGKE
        ;;
        AKS)
        deployAKS
        ;;
        *)
        echo "No supported Cloud Provider (GCP or AKS) detected."
        exit 1
        ;;
    esac
else
    exit 1
fi


echo "Cluster created"

echo "Deploying OneAgent Operator"

../utils/dynatrace/deploy-dt-operator.sh

case $CLOUD_PROVIDER in
        GKE)
        echo "-----------------------"
        echo "Deployment Complete"
        echo "-----------------------"
        ;;
    esac



