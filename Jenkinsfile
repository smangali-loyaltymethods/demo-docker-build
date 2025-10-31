pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub'
        IMAGE_NAME = 'srikanth4402/mouneesh_uncle'
        TAG = 'latest'
        VOLUME_NAME = 'shared_data'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/smangali-loyaltymethods/demo-docker-build.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${TAG}", ".")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.image("${IMAGE_NAME}:${TAG}").push()
                }
            }
        }

        stage('Run Containers with Shared Volume') {
            steps {
                script {
                    sh '''
                        # Stop and clean up previous runs if any
                        docker stop containerA containerB || true
                        docker rm containerA containerB || true
                        docker volume rm ${VOLUME_NAME} || true

                        # Create a fresh shared volume
                        docker volume create ${VOLUME_NAME}

                        # Start the first container and write data
                        docker run -d --name containerA -v ${VOLUME_NAME}:/demo ${IMAGE_NAME}:${TAG} sleep infinity
                        docker exec containerA sh -c 'echo "Hello from containerA!" > /demo/hello.txt'

                        # Start the second container and mount same volume
                        docker run -d --name containerB -v ${VOLUME_NAME}:/demo ${IMAGE_NAME}:${TAG} sleep infinity

                        # Verify shared file
                        docker exec containerB cat /demo/hello.txt
                    '''
                }
            }
        }
    }
}

