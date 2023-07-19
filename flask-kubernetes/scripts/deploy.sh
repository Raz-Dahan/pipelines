#!/bin/bash

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials nasa-cluster

cd ${Pipeline_Path}/flask-chart
echo 'Getting values.yaml'
bash ../scripts/get_values.sh
rm flask-chart-0.1.0.tgz
helm package .
if helm list | grep -q -i "flask-chart"; then
    echo 'Chart already installed'
    echo 'Performing update...'
    helm upgrade flask-chart flask-chart-0.1.0.tgz --reuse-values -f values.yaml
else
    echo 'Installing the chart...'
    helm install flask-chart flask-chart-0.1.0.tgz
fi