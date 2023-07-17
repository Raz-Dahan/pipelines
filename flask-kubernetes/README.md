# CI/CD Project

Welcome! This project focuses on continuous integration and continuous deployment using Jenkins, Docker and Kubernetes.<br />
It includes a Flask application, a Jenkinsfile for build, test, approval, and deploy stages, as well as scripts for deployment and testing.

- This project is designed so that anyone can use it. You just need to perform all the preparations and modify the variable names to suit your needs.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Running the Project](#running-the-project)
- [Contributing](#contributing)
- [Acknowledgements](#acknowledgements)
- [Contact](#contact)

## Prerequisites

Before running this project, please ensure that you have the following:

- Open Ubuntu server
- install Jenkins, Docker, aws-cli, gcloud-cli
- add jenkins user to docker group.
- Perform `aws configure` with the jenkins user.
- Perform `docker login -u <user>` with Docker Hub PAT as password with the jenkins user.
- Perform `gcloud auth login <account>` with jenkins user.
- A GCP GKE cluster.
- An GCP GCE instance named "test".
- ADD .env file to your jenkins server at `/var/lib/jenkins`, configured as this:
   ```
   API_KEY=<your API key>   # Remove this line if you're not using an API in your Flask application
   DOCKER_USERNAME=<your Docker Hub username>
   DOCKER_PASSWORD=<your Docker Hub password>
   ```
- Note: not all variables are defined so make sure double check Jenkinsfile, deploy.sh, maifest.yaml and docker-compose.yml

## Getting Started

To get started with this project, please follow these steps:

1. Launch Jenkins on your server and set it up.

2. Add the following line to the sudoers file on the Jenkins server to allow Jenkins to restart the Flask service:

   ```
   jenkins ALL=(ALL) NOPASSWD: /bin/systemctl restart flask.service
   ```

3. Create a new pipeline job.

4. In the pipeline configuration, specify the Jenkinsfile from `https://github.com/Raz-Dahan/pipelines.git`.

5. Customize the Jenkinsfile to enable/disable the approval stage based on your requirements.

## Running the Project

Once you have completed the setup, you can run the project using the following steps:

1. Build and deploy the project by running the Jenkins pipeline job.

2. The pipeline will build the Docker image, run tests on a VM using Docker compose, and deploy the Flask application and Redis database on a cluster using Kubernetes.

3. Access the Flask application by entering the public IP address of the Load balancer service in your web browser.

4. Test the application's functionality, ensuring it meets the requirements.

- Notice that the pipeline keep the last 10 images on Docker Hub for versions control and the last five images on the instances for troubleshooting

## Contributing

If you wish to contribute to this project, please follow the standard GitHub workflow:

1. Fork the repository.

2. Create a new branch for your feature/bug fix.

3. Make your changes and commit them.

4. Push your changes to your forked repository.

5. Submit a pull request to the main repository.

## Acknowledgements

- Special thanks to the Kubernetes, Jenkins and Docker communities for their fantastic tools and resources.

- Special thank to Google on good trustable services and their great documentation.

## Contact

If you have any questions or suggestions regarding this project, feel free to contact the project creator and maintainer at [razdahan31@gmail.com](mailto:razdahan31@gmail.com).
