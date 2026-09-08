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

                    /kaniko/executor \
                    --context ${WORKSPACE} \
                    --dockerfile ${WORKSPACE}/Dockerfile \
                    --destination ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/devops/go-server:latest
                '''
            }
        }
    }
}
