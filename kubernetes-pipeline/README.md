# CI/CD Project

Welcome to my Continuous Integration and Deployment Project!<br /> This project showcases the implementation of a modern CI/CD pipeline using industry-standard tools and practices. It focuses on streamlining the software development process, ensuring code quality, and automating deployment to various environments.

## Overview

In today's fast-paced software development landscape, CI/CD has become an essential practice. It involves automating the integration of code changes, running tests, and deploying updates efficiently and consistently.<br /> My project employs the following key technologies:

- **Jenkins**: An automation server that orchestrates the CI/CD pipeline, from building and testing to deploying applications.
- **Docker**: A platform that enables packaging applications and their dependencies into lightweight, portable containers.
- **Kubernetes**: An open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications.
- **Helm**: A package manager for Kubernetes that simplifies the deployment and management of applications.
- **Prometheus and Grafana**: Tools for monitoring and visualizing the health and performance of applications and infrastructure.
- **Terraform**: Infrastructure as Code (IaC) tool for managing cloud resources in a consistent and repeatable manner.

## How It Works

![Pipleline's Diargam](https://raz-jpgs-archive.s3.eu-central-1.amazonaws.com/diagram_k8s.jpg)


My project provides a practical example of how these tools come together in a seamless workflow:

1. Developers make code changes and commit them to the version control repository.
2. Jenkins automatically kicks off a pipeline:
   - It builds a Docker image of the application, ensuring consistency across different environments.
   - Runs automated tests to validate code changes.
   - Approves changes for deployment based on predefined criteria.
   - Deploys the application to a Kubernetes cluster.
3. The application becomes accessible via Cluster's Load Balancer's public IP address.
4. Prometheus and Grafana provide real-time monitoring, helping ensure application health and performance.
5. The infrastructure can be managed as code using Terraform, enabling easy replication and scaling.

## Pipeline Setup

1. Install [Jenkins](https://www.jenkins.io/doc/book/installing/linux/#debianubuntu "Install Jenkins"), [Docker](https://docs.docker.com/engine/install/ubuntu/ "Install Docker"), [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html "Install AWS CLI"), [gcloud CLI](https://cloud.google.com/sdk/docs/install "Install gcloud CLI") and [Helm](https://helm.sh/docs/intro/install/ "Install Helm") on Ubuntu server.

2. ADD .env file to your jenkins server at `/var/lib/jenkins`, configured as this:
   ```
   API_KEY=<your API key>   # Remove this line if you're not using an API in your Flask application
   DOCKER_USERNAME=<your Docker Hub username>
   DOCKER_PASSWORD=<your Docker Hub password>
   ```

3. Launch Jenkins on your server and set new pipeline job.

4. Change variables in all relavent files.

5. Build and deploy the project by running the Jenkins pipeline job.

6. Access the Flask application by entering the public IP address of the Load balancer service in your web browser.

7. To access the monitoring tools go to gcp-console > kubernetes engine > "servicess & ingress" >  prometheus-grafana > edit > change "metadata: type" to LoadBalancer, then enter these Grafana cardentials:
```
	username: admin
	password: prom-operator
```

## Contact

For any inquiries or further information about this project, please feel free to contact the project creator and maintainer at [razdahan31@gmail.com](mailto:razdahan31@gmail.com).
