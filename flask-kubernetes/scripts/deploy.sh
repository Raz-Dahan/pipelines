#!/bin/bash

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials nasa-cluster

cd /var/lib/jenkins/workspace/${Pipeline_Path}/scripts
echo 'Getting ConfigMap...'
bash get_config.sh

## kubectl apply -f configmap.yaml
## kubectl apply -f manifest-test.yaml
kubectl apply -f manifest.yaml

GET_IMAGE_TAG=$(kubectl describe deployment.apps/flask-deployment | grep -i "image:" | awk '{split($2, a, ":"); print a[2]}')
