#!/bin/bash

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials prod-cluster --zone us-central1-a

if helm list -n monitoring | grep -q "prometheus"; then
    echo "Prometheus is already installed."
else
    kubectl create namespace monitoring
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
    echo "Prometheus installed."
fi
