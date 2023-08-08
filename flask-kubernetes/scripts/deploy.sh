#!/bin/bash

Chart_Name="NANA-app"
GCP_Bucket="chart-packages"

# Flag settings
usage() {
    echo "Usage: $0 [--test]"
    echo "Options:"
    echo "  --test  Run tests"
    exit 1
}

# Testing
run_tests() {
    EXTERNAL_IP=$(kubectl get service flask-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
    http_response=$(curl -s -o /dev/null -w "%{http_code}" ${EXTERNAL-IP}:80)
    if [[ $http_response == 200 ]]; then
        echo "Flask app returned a 200 status code. Test passed!"
        gsutil cp ${Pipeline_Path}/chart/$Chart_Name-1.${BUILD_NUMBER}.0.tgz  gs://$GCP_Bucket
    else
        echo "Flask app returned a non-200 status code: $http_response. Test failed!"
        exit 1
    fi
}

helm_handaling() {
    if helm list | grep -q -i "$Chart_Name"; then
        echo 'Chart already installed'
        echo 'Performing upgrade...'
        helm upgrade $Chart_Name $Chart_Name-1.$BUILD_NUMBER.0.tgz --reuse-values -f values.yaml
    else
        echo 'Installing the chart...'
        helm install $Chart_Name $Chart_Name-1.$BUILD_NUMBER.0.tgz
    fi
}

# Deploying
run_deployment() {
    export USE_GKE_GCLOUD_AUTH_PLUGIN=True
    gcloud container clusters get-credentials $CLUSTER_TIER --zone us-central1-a

    if [[ $CLUSTER_TIER == "test-cluster" ]]; then
        cd ${Pipeline_Path}/chart
        echo 'Getting chart yamls...'
        bash ${Pipeline_Path}/scripts/get_chart_yamls.sh
        helm package .
        helm_handaling
    elif [[ $CLUSTER_TIER == "prod-cluster" ]]; then
        gsutil cp "gs://$GCP_BUCKET/$Chart_Name-1.$BUILD_NUMBER.0.tgz" .
        helm_handaling
    fi
}

# Flag handling
if [[ $# -eq 1 && "$1" == "--test" ]]; then
    CLUSTER_TIER="test-cluster"
    run_deployment
    run_tests
elif [[ $# -eq 0 ]]; then
    CLUSTER_TIER="prod-cluster"
    run_deployment
else
    usage
fi
