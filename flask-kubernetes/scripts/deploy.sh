#!/bin/bash

# Variables
Chart_Name="nasa-app"
VER="1.$BUILD_NUMBER.0"

# Flag settings
usage() {
    echo "Usage: $0 [--test]"
    echo "Options:"
    echo "  --test  Run tests"
    exit 1
}

# Testing
run_tests() {
    if helm test $Chart_Name; then
        echo 'Tests passed.'
    else
        echo 'Tests failed.'
        exit 1
    fi
    EXTERNAL_IP=$(kubectl get service flask-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
    http_response=$(curl -s -o /dev/null -w "%{http_code}" ${EXTERNAL_IP}:80)
    if [[ $http_response == 200 ]]; then
        echo "LoadBalancer returned a 200 status code. Test passed!"
    else
        echo "LoadBalancer returned a non-200 status code: $http_response. Test failed!"
        exit 1
    fi
}

# Building
helm_build() {
    echo 'Getting chart yamls...'
    bash ${Pipeline_Path}/scripts/get_chart_yamls.sh
    helm package .
}

# Deploying
helm_deployment() {
    export USE_GKE_GCLOUD_AUTH_PLUGIN=True
    gcloud container clusters get-credentials $CLUSTER_TIER --zone us-central1-a

    if helm list | grep -q -i "$Chart_Name"; then
        echo 'Chart already installed'
        echo 'Performing upgrade...'
        helm upgrade $Chart_Name $Chart_Name-$VER.tgz --reuse-values -f values.yaml
    else
        echo 'Installing the chart...'
        helm install $Chart_Name $Chart_Name-$VER.tgz
    fi
}



main() {
    cd ${Pipeline_Path}/chart
    if [[ $# -eq 1 && "$1" == "--test" ]]; then
        CLUSTER_TIER="test-cluster"
        helm_build
        helm_deployment
        run_tests
    elif [[ $# -eq 0 ]]; then
        CLUSTER_TIER="prod-cluster"
        helm_deployment
    else
        usage
    fi
}

main $@