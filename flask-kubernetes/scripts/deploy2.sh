#!/bin/bash

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials nasa-cluster

cd ${Pipeline_Path}/flask-chart
echo 'Getting chart yamls...'
bash ${Pipeline_Path}/scripts/get_chart_yamls.sh
helm package .
if helm list | grep -q -i "flask-chart"; then
    echo 'Chart already installed'
    echo 'Performing upgrade...'
    helm upgrade flask-chart flask-chart-1.$BUILD_NUMBER.tgz --reuse-values -f values.yaml
else
    echo 'Installing the chart...'
    helm install flask-chart flask-chart-1.$BUILD_NUMBER.tgz
fi
