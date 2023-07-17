#!/bin/bash

INSTANCE_IP=$1
DOCKER_BUILD=$2

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/raz-key.pem ec2-user@${INSTANCE_IP} "
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
echo 'Stopping and removing existing Docker containers...'
sudo docker stop \$(sudo docker ps -aq) && sudo docker rm \$(sudo docker ps -aq)
echo 'Removing images if there are more than 5...'

IMAGES_SUM=\$(sudo docker images | tail -n +2 | wc -l)
OLDEST_BUILD=\$(sudo docker images --no-trunc --format '{{.Repository}}:{{.Tag}}' | tail -n +2 | sort -V | head -n 1)

if [ "\$IMAGES_SUM" -gt 4 ]; then
    sudo docker rmi \"\$OLDEST_BUILD\"
else
    echo 'No need to delete the oldest build. Total image count is less than or equal to 5.'
fi

echo 'Pulling image from Docker Hub to instance...'
sudo docker pull ${DOCKER_BUILD}
echo 'Running the flask...'
sudo docker run -d -p 5000:5000 --restart always ${DOCKER_BUILD}
"

while getopts ":test" option; do
  case $option in
    test)
      /bin/bash /var/lib/jenkins/workspace/flask-docker-pipeline/flask-docker/tests.sh
      ;;
    *)
      echo "the only flag is '-test'"
      ;;
  esac
done
