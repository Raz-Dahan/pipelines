#!/bin/bash

if ! command -v jq &> /dev/null; then
    echo 'jq is not installed. Installing jq...'
    sudo apt install jq -y
    echo 'jq has been installed.'
else
    echo 'jq is already installed.'
fi
    
REPO='razdahan31/flask-k8s'
TAG=$(curl -s "https://hub.docker.com/v2/repositories/${REPO}/tags" | jq -r '.results[0].name')
echo "VER=$TAG" > .env
