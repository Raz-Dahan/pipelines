#!/bin/bash
NAME='VER='
REPO='razdahan31/flask-docker'
TAG=$(curl -s "https://hub.docker.com/v2/repositories/${REPO}/tags" | jq -r '.results[0].name')
echo $NAME$TAG > .env
