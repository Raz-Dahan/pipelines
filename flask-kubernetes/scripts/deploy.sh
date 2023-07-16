#!/bin/bash

cd /var/lib/jenkins/workspace/${Pipeline_Path}/scripts
echo 'Getting .env file...'
bash get-ver.sh

IS_APPLIED=$(kubectl get -f manifest.yaml --ignore-not-found)

if [[ -z "$IS_APPLIED" ]]; then
    kubectl apply -f manifest.yaml
    exit 0
else
    echo "The manifest.yaml is already applied."
fi

GET_IMAGE_TAG=$(kubectl describe deployment.apps/flask-deployment | grep -i "image:" | awk '{split($2, a, ":"); print a[2]}')

if [[ "$GET_IMAGE_TAG" == "$VER" ]]; then
    kubectl set image deployment.apps/flask-deployment flask=razdahan31/flask-k8s:$VER
    exit 0
fi

