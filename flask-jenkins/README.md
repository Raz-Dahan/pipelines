# Flask Project

Welcome! This project utilizes Flask and Crypto API to display cryptocurrencies of Bitcoin Etherium and Litecoin. 
The repository includes the necessary files to set up the project and run it as CI/CD pipeline on EC2 instances using Jenkins and Ansible.

## Prerequisites

Before running this project, please ensure that you have the following:

- An EC2 instance with the `platform:production` tag.
- Another EC2 instance with the `platform:test` tag.
- ensure that you have an S3 bucket.
- Jenkins installed on your server (Ubuntu).
- AWS IAM role with full access to S3 and EC2.

## Getting Started

To get started with this project, please follow these steps:

1. Clone the repository to your Jenkins server:

   ```
   git clone https://github.com/Raz-Dahan/flask-project.git
   ```

2. Configure the AWS credentials on your local machine by setting the necessary environment variables.

3. Set up the EC2 instances with the appropriate tags and IAM roles, make sure to put your rsa key in the path mentioned in Jenkinsfile and tests.sh and pair it to your instances

4. Configure the Jenkins pipeline:

   - Launch Jenkins on your server and set it up.
   - Create a new pipeline job.
   - In the pipeline configuration, specify the Jenkinsfile from this repository.
   - Update the S3 bucket name in the Jenkinsfile to match your own bucket.
5. Ensure that your sudoers file on your Jenkins server includes the following command to allow Jenkins to run the tests properly:

   ```
   jenkins ALL=(ALL) NOPASSWD: /bin/systemctl restart flask.service
   ```


## Running the Project

Once you have completed the setup, you can run the Flask project using the following steps:

1. Build the project by running the Jenkins pipeline job.

2. The pipeline will deploy the Flask application on the EC2 instances. The production instance will serve the website with the crypto coins currencies.

3. Access the website by entering the production instance's public IP address in your web browser.

The project keeps track of the last 5 builds in an S3 bucket.

## Contributing

If you wish to contribute to this project, please follow the standard GitHub workflow:

1. Fork the repository.

2. Create a new branch for your feature/bug fix.

3. Make your changes and commit them.

4. Push your changes to your forked repository.

5. Submit a pull request to the main repository.

## Acknowledgements

- The project uses API from the CoinGecko website. Visit [CoinGecko](https://www.coingecko.com/) to explore a wide range of Crypto information and marketplace.
- Thanks to the Flask and Jenkins communities for their excellent tools and documentation.

## Contact

If you have any questions or suggestions regarding this project, feel free to contact the project creator and maintainer at razdahan31@gmail.com.
