pipeline {
    agent none

    environment {
        AWS_REGION = 'eu-west-3'
    }

    stages {
        stage('Build Docker Image') {
            agent {
                label 'aws-fargate'
            }
            steps {
                checkout scm

                sh '''
                    mkdir -p /kaniko/.docker
                    echo "{\\"credsStore\\":\\"ecr-login\\"}" > /kaniko/.docker/config.json

                    HEAD_COMMIT=$(git rev-parse --short HEAD)
                    TAG=$HEAD_COMMIT-$BUILD_NUMBER

                    /kaniko/executor \
                    --context ${WORKSPACE} \
                    --dockerfile ${WORKSPACE}/Dockerfile \
                    --destination 138465306868.dkr.ecr.${AWS_REGION}.amazonaws.com/devops/go-server:latest \
                    --destination 138465306868.dkr.ecr.${AWS_REGION}.amazonaws.com/devops/go-server:${TAG}
                '''
            }
        }
    }
}
