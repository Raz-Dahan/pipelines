#!/bin/bash

usage() {
  echo "Usage: $0 [--test] INSTANCE_IP DOCKER_BUILD"
  echo "Options:"
  echo "  --test  Run tests"
  exit 1
}

run_tests() {
  /bin/bash /var/lib/jenkins/workspace/flask-docker-pipeline/pipelines/flask-docker/scripts/tests.sh
}

# command line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    --test)
      run_tests_flag=true
      shift
      ;;
    *)
      break
      ;;
  esac
done

# Check if all required arguments are provided, if not prase usage info
if [ $# -lt 2 ]; then
  usage
fi

# Change the path to your pipeline
Pipeline_Path="flask-docker-pipeline/pipelines/flask-docker"
# Change the key to your aws rsa key pair
RSA_Key="raz-key.pem"

INSTANCE_IP=$1
DOCKER_BUILD=$2

# Dependencies
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/${RSA_Key} ec2-user@${INSTANCE_IP} "
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo 'Stopping and removing existing Docker containers...'
sudo docker stop \$(sudo docker ps -aq) && sudo docker rm \$(sudo docker ps -aq)
echo 'Removing images if there are more than 5...'
IMAGES_SUM=\$(sudo docker images | tail -n +2 | wc -l)
OLDEST_BUILD=\$(sudo docker images --no-trunc --format '{{.Repository}}:{{.Tag}}' | tail -n +2 | sort -V | head -n 1)
if [ "\$IMAGES_SUM" -gt 5 ]; then
    sudo docker rmi \"\$OLDEST_BUILD\"
else
    echo 'No need to delete the oldest build. Total image count is less than or equal to 5.'
fi
"

echo 'Copying docker-compose.yml and .env to instance...'
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/${RSA_Key} /var/lib/jenkins/workspace/${Pipeline_Path}/docker-compose.yml /var/lib/jenkins/workspace/${Pipeline_Path}/scripts/get-ver.sh ec2-user@${INSTANCE_IP}:/home/ec2-user

# Deployment
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/${RSA_Key} ec2-user@${INSTANCE_IP} "
echo 'Pulling image from Docker Hub to instance...'
sudo docker pull \${DOCKER_BUILD}
echo 'Getting .env file...'
/bin/bash get-ver.sh
echo 'Running the docker compose...'
sudo docker-compose up -d
"

# Run tests if the flag requested
if [ "$run_tests_flag" = true ]; then
  echo 'Running tests...'
  run_tests
fi
