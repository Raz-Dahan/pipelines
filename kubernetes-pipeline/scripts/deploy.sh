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
    if helm test chart; then
        echo 'Tests passed.'
    else
        echo 'Tests failed.'
        curl 'https://us-central1-named-signal-392608.cloudfunctions.net/mark_failures'
        exit 1
    fi
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