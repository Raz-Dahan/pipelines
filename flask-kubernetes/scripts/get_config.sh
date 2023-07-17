#!/bin/bash

# Get VER variable

if ! command -v jq &> /dev/null; then
    echo 'jq is not installed. Installing jq...'
    sudo apt install jq -y
    echo 'jq has been installed.'
else
    echo 'jq is already installed.'
fi
    
NAME='VER='
REPO='razdahan31/flask-k8s'
TAG=$(curl -s "https://hub.docker.com/v2/repositories/${REPO}/tags" | jq -r '.results[0].name')
echo $NAME$TAG > .env

# Get config map

ENV_FILE=".env"
OUTPUT_FILE="configmap.yaml"
NAMESPACE="default"

echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: dotenv
  namespace: $NAMESPACE
data:" > "$OUTPUT_FILE"

while IFS= read -r line; do
  key=$(echo "$line" | cut -d '=' -f 1)
  value=$(echo "$line" | cut -d '=' -f 2-)
  echo "  $key: $value" >> "$OUTPUT_FILE"
done < "$ENV_FILE"

