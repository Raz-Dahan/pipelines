#!/bin/bash

echo 'Building Docker image...'
cd ${Pipeline_Path}/NASA/
cp /var/lib/jenkins/.env .
docker build -t ${App_Package} .
echo 'Pushing to Docker Hub...'
docker push ${App_Package}

echo 'Packaging helm...'
cd ${Pipeline_Path}/chart/

bash ${Pipeline_Path}/scripts/get_chart_yamls.sh
helm package .