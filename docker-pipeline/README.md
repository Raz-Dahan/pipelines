# Flask Docker Project

Welcome to the Flask Project repository! This project utilizes Flask and display a random Alpaca GIF of the day every time you refresh the website. The repository includes the necessary files to set up the project and run it on EC2 instances using Jenkins.

## Prerequisites

Before running this project, please ensure that you have the following:

- An EC2 instance with the `platform:production` tag.
- Another EC2 instance with the `platform:test` tag.
- Jenkins installed on your server (Ubuntu).
- aws-cli configured
- AWS IAM role with full access to S3 and EC2.
- Docker installed.
- DockerHub account

## Getting Started

To get started with this project, please follow these steps:

1. Clone the repository to your Jenkins server:

   ```
   git clone https://github.com/Raz-Dahan/pipelines.git
   cd pipelines/docker-pipeline
   ```

2. Configure the AWS credentials on your local machine by setting the necessary environment variables.

3. Set up the EC2 instances with the appropriate tags and IAM roles, make sure to put your rsa key in the path mentioned in Jenkinsfile and tests.sh and pair it to your instances

4. Configure the Jenkins pipeline:

   - Launch Jenkins on your server and set it up.
   - Create a new pipeline job.
   - In the pipeline configuration, specify the Jenkinsfile from this repository.

## Running the Project

Once you have completed the setup, you can run the Flask project using the following steps:

1. Build the project by running the Jenkins pipeline job.

2. The pipeline will deploy the Flask application on the EC2 instances. The production instance will serve the website with the Alpaca GIF of the day.

3. Access the website by entering the production instance's public IP address in your web browser.

4. Every time you refresh the website, a new random Alpaca GIF of the day will be displayed.


## Contributing

If you wish to contribute to this project, please follow the standard GitHub workflow:

1. Fork the repository.

2. Create a new branch for your feature/bug fix.

3. Make your changes and commit them.

4. Push your changes to your forked repository.

5. Submit a pull request to the main repository.

## Acknowledgements

- The project uses GIFs from the GIPHY website. Visit [GIPHY](https://giphy.com/) to explore a wide range of GIFs for your projects.
- Thanks to the Flask and Jenkins communities for their excellent tools and documentation.

## Contact

If you have any questions or suggestions regarding this project, feel free to contact the project creator and maintainer at razdahan31@gmail.com.
