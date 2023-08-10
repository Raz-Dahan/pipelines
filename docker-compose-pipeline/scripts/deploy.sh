#!/bin/bash

# Change the path to your pipeline
Pipeline_Path="docker-compose-pipeline/pipelines/docker-compose-pipeline"

# Flag's functions
usage() {
  echo "Usage: $0 [--test] INSTANCE_IP DOCKER_BUILD"
  echo "Options:"
  echo "  --test  Run tests"
  exit 1
}

run_tests() {
  /bin/bash /var/lib/jenkins/workspace/${Pipeline_Path}/scripts/tests.sh
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


# Change the key to your aws rsa key pair
RSA_Key="raz-key.pem"

INSTANCE_IP=$1
DOCKER_BUILD=$2


echo 'Copying docker-compose.yml and .env to instance...'
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/${RSA_Key} /var/lib/jenkins/workspace/${Pipeline_Path}/docker-compose.yml /var/lib/jenkins/workspace/${Pipeline_Path}/scripts/get-ver.sh ec2-user@${INSTANCE_IP}:/home/ec2-user

# Dependencies
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/${RSA_Key} ec2-user@${INSTANCE_IP} "
sudo yum update -y
if ! command -v docker &> /dev/null; then
    echo 'Docker is not installed. Installing Docker...'
    sudo yum install docker -y
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
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
echo 'Getting .env file...'
/bin/bash get-ver.sh
echo 'Stopping and removing existing Docker containers...'
sudo docker-compose down
echo 'Running the docker compose...'
sudo docker-compose up -d
"

# Run tests if the flag requested
if [ "$run_tests_flag" = true ]; then
  echo 'Running tests...'
  run_tests
fi
