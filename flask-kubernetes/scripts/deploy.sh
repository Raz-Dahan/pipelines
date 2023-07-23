#!/bin/bash


#!/bin/bash

# Flag settings
usage() {
    echo "Usage: $0 [--test]"
    echo "Options:"
    echo "  --test  Run tests"
    exit 1
}

# Testing
run_tests() {
    if helm test flask-chart; then
        echo 'Tests passed.'
    else
        echo 'Tests failed.'
        exit 1
    fi
}

# Deploying
run_deployment() {
    export USE_GKE_GCLOUD_AUTH_PLUGIN=True
    gcloud container clusters get-credentials $CLUSTER_TIER

    cd ${Pipeline_Path}/chart
    echo 'Getting chart yamls...'
    bash ${Pipeline_Path}/scripts/get_chart_yamls.sh
    helm package .
    if helm list | grep -q -i "flask-chart"; then
        echo 'Chart already installed'
        echo 'Performing upgrade...'
        helm upgrade flask-chart flask-chart-1.$BUILD_NUMBER.0.tgz --reuse-values -f values.yaml
    else
        echo 'Installing the chart...'
        helm install flask-chart flask-chart-1.$BUILD_NUMBER.0.tgz
    fi
}

# Flag handling
if [[ $# -eq 1 && "$1" == "--test" ]]; then
    CLUSTER_TIER="test-cluster --zone us-east1"
    run_deployment
    run_tests
elif [[ $# -eq 0 ]]; then
    CLUSTER_TIER="prod-cluster --zone us-central1"
    run_deployment
else
    usage
fi
