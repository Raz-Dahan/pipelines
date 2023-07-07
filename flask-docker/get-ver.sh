#!/bin/bash
sudo apt install jq -y
NAME='VER='
TAG=$(curl -s "https://hub.docker.com/v2/repositories/razdahan31/flask-docker/tags" | jq -r '.results[0].name')
echo $NAME$TAG > .env
