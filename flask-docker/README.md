# Docker CI/CD Project

Welcome! This project focuses on continuous integration and continuous deployment using Jenkins and Docker. It includes a Flask application, a Jenkinsfile for build, test, approval, and deploy stages, as well as scripts for deployment and testing.

## Prerequisites

Before running this project, please ensure that you have the following:

- Jenkins and Docker installed on your server (Ubuntu).
- Jenkins user added to the Docker group.
- AWS CLI configured and do Docker login with the Jenkins user.
- An EC2 instance with the `platform:production` tag.
- An EC2 instance with the `platform:test` tag.
- Custom RSA key pairs for the instances, owned by the Jenkins user.

## Getting Started

To get started with this project, please follow these steps:

1. Clone the repository to your Jenkins server:

   ```
   git clone https://github.com/your-username/your-repo.git
   ```

2. Configure the AWS CLI on your Jenkins server by running `aws configure` with the Jenkins user.

3. Set up the EC2 instances with the appropriate tags and ensure the RSA key pairs are owned by the Jenkins user and placed in the correct paths.

4. To install `jq` if the instance is based on Debian Linux add this at the beginning of get-ver.sh:

   ```
   sudo apt install jq -y
   ```

5. Add the following line to the sudoers file on the Jenkins server to allow Jenkins to restart the Flask service:

   ```
   jenkins ALL=(ALL) NOPASSWD: /bin/systemctl restart flask.service
   ```

6. Configure the Jenkins pipeline:

   - Launch Jenkins on your server and set it up.
   - Create a new pipeline job.
   - In the pipeline configuration, specify the Jenkinsfile from this repository.
   - Customize the Jenkinsfile to enable/disable the build, test, and approval stages based on your requirements.
   - Update the necessary AWS parameters.

## Running the Project

Once you have completed the setup, you can run the project using the following steps:

1. Build and deploy the project by running the Jenkins pipeline job.

2. The pipeline will build the Docker image, run tests, and deploy the Flask application and Redis database using Docker Compose.

3. Access the Flask application by entering the public IP address of the production instance in your web browser.

4. Test the application's functionality, ensuring it meets the requirements.

## Contributing

If you wish to contribute to this project, please follow the standard GitHub workflow:

1. Fork the repository.

2. Create a new branch for your feature/bug fix.

3. Make your changes and commit them.

4. Push your changes to your forked repository.

5. Submit a pull request to the main repository.

## Acknowledgements

- Special thanks to the Jenkins and Docker communities for their fantastic tools and resources.

## Contact

If you have any questions or suggestions regarding this project, feel free to contact the project creator and maintainer at [razdahan31@gmail.com](mailto:razdahan31@gmail.com).
