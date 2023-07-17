#!/bin/bash

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials nasa-cluster

cd /var/lib/jenkins/workspace/${Pipeline_Path}/scripts
echo 'Getting .env file...'
bash get_config.sh
export $(cat .env | xargs)

kubectl apply -f configmap.yaml

kubectl apply -f manifest.yaml


GET_IMAGE_TAG=$(kubectl describe deployment.apps/flask-deployment | grep -i "image:" | awk '{split($2, a, ":"); print a[2]}')

if [[ "$GET_IMAGE_TAG" == "$VER" ]]; then
    echo "Setting new image tag=$VER on the deployment..."
    kubectl set image deployment.apps/flask-deployment flask=razdahan31/flask-k8s:$VER
    exit 0
else
    echo "Newest image is already set."
fi
