#!/bin/bash

if ! command -v jq &> /dev/null; then
    echo 'jq is not installed. Installing jq...'
    sudo apt install jq -y
    echo 'jq has been installed.'
fi

REPO='razdahan31/flask-k8s'
TAG=$(curl -s "https://hub.docker.com/v2/repositories/${REPO}/tags" | jq -r '.results[0].name')
OUTPUT_FILE="configmap.yaml"
NAMESPACE="default"

echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: dotenv
  namespace: $NAMESPACE
data:" > "$OUTPUT_FILE"

key="VER"
value=$TAG
echo "  $key: $value" >> "$OUTPUT_FILE"

echo "configmap.yaml created"