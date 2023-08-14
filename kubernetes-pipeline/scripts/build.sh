echo 'Cloning from GitHub...'
sh 'git clone https://github.com/Raz-Dahan/pipelines.git'
cd ${Pipeline_Path}/NASA/
cp /var/lib/jenkins/.env .
echo 'Building Docker image...'
docker build -t ${App_Package} .
echo 'Pushing to Docker Hub...'
docker push ${App_Package}