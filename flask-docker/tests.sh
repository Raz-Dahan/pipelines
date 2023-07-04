#!/bin/bash
INSTANCE_IP=$(aws ec2 describe-instances --region eu-central-1 --filters Name=tag:platform,Values=test --query 'Reservations[].Instances[].PublicIpAddress' --output text)

# Test the http status
http_response=$(curl -s -o /dev/null -w "%{http_code}" ${INSTANCE_IP}:5000)

if [[ $http_response == 200 ]]; then
    echo "Flask app returned a 200 status code. Test passed!"
else
    echo "Flask app returned a non-200 status code: $http_response. Test failed!"
    exit 1
fi

# Test if Redis database responding
db_respone=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/raz-key.pem ec2-user@${INSTANCE_IP} "sudo docker exec redis sh -c 'redis-cli ping'") &> /dev/null

if [[ $db_respone == 'PONG' ]]; then
    echo "Redis database returned PONG. Test passed!"
else
    echo "Redis database could'nt connect. Test failed!"
    exit 1
fi