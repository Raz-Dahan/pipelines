#!/bin/bash

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials nasa-cluster

cd ${Pipeline_Path}/chart
echo 'Getting chart yamls...'
bash ${Pipeline_Path}/scripts/get_chart_yamls.sh
helm package .
if helm list | grep -q -i "flask-chart"; then
    echo 'Chart already installed'
    if helm test flask-chart; then
        echo 'Tests passed. Proceeding with upgrade...'
        echo 'Performing upgrade...'
        helm upgrade flask-chart flask-chart-1.$BUILD_NUMBER.0.tgz --reuse-values -f values.yaml
    else
        echo 'Tests failed. Skipping upgrade...'
        exit 1
    fi
else
    echo 'Installing the chart...'
    helm install flask-chart flask-chart-1.$BUILD_NUMBER.0.tgz
    echo 'Running test...'
    if helm test flask-chart; then
        echo 'Tests passed.'
    else
        echo 'Tests failed.'
        exit 1
    fi
fi