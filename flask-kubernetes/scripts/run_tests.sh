#!/bin/bash

INSTANCE_IP = sh(script: "gcloud compute instances describe test --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'", returnStdout: true).trim()

# Test the http status
http_response=$(curl -s -o /dev/null -w "%{http_code}" ${INSTANCE_IP}:80)

if [[ $http_response == 200 ]]; then
    echo "Flask app returned a 200 status code. Test passed!"
else
    echo "Flask app returned a non-200 status code: $http_response. Test failed!"
    exit 1
fi

# Test if Redis database responding
db_response=$(gcloud compute ssh --project=named-signal-392608 --zone=us-central1-a test --ssh-flag="-o UserKnownHostsFile=/dev/null -o CheckHostIP=no -o StrictHostKeyChecking=no" --command "sudo docker exec redis sh -c 'redis-cli ping'")

if [[ $db_respone == 'PONG' ]]; then
    echo "Redis database returned PONG. Test passed!"
else
    echo "Redis database could'nt connect. Test failed!"
    exit 1
fi