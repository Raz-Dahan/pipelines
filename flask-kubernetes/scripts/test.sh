#!/bin/bash

INSTANCE_NAME="test"
PROJECT_ID="named-signal-392608"
ZONE="us-central1-a"
## change "cd" path in COMMANDS to your GitHub repository

# Inatallation, Version control and Deployment commands to be executed within the SSH session
COMMANDS="
echo 'Intalling dependencies...'
sudo apt update -y
if ! command -v docker &> /dev/null; then
    echo 'Docker is not installed. Installing Docker...'
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
else
    echo 'Docker is already installed.'
fi
if ! command -v docker-compose &> /dev/null; then
    echo 'Docker Compose is not installed. Installing Docker Compose...'
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo 'Docker Compose has been installed.'
else
    echo 'Docker Compose is already installed.'
fi
echo 'Setting up workspace...'
git clone https://github.com/Raz-Dahan/pipelines.git
cd /home/jenkins/pipelines/flask-kubernetes/
echo 'Stopping and removing existing Docker containers...'
sudo docker-compose down
echo 'Getting .env file...'
bash scripts/get-dotenv.sh
echo 'Running the docker compose...'
sudo docker-compose up -d
"

# Execute commands in the SSH connection 
gcloud compute ssh --project=$PROJECT_ID --zone=$ZONE $INSTANCE_NAME --ssh-flag="-o UserKnownHostsFile=/dev/null -o CheckHostIP=no -o StrictHostKeyChecking=no" --command "$COMMANDS"


echo 'Running tests...'

# Get test instance's IP
INSTANCE_IP=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --project=$PROJECT_ID --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Test the http status
http_response=$(curl -s -o /dev/null -w "%{http_code}" ${INSTANCE_IP}:80)

if [[ $http_response == 200 ]]; then
    echo "Flask app returned a 200 status code. Test passed!"
else
    echo "Flask app returned a non-200 status code: $http_response. Test failed!"
    exit 1
fi

# Test if Redis database responding
db_respone=$(gcloud compute ssh --project=$PROJECT_ID --zone=$ZONE $INSTANCE_NAME --ssh-flag="-o UserKnownHostsFile=/dev/null -o CheckHostIP=no -o StrictHostKeyChecking=no" --command "sudo docker exec redis sh -c 'redis-cli ping'")

if [[ $db_respone == 'PONG' ]]; then
    echo "Redis database returned PONG. Test passed!"
else
    echo "Redis database could'nt connect. Test failed!"
    exit 1
fi