pipeline {
    agent {
        label 'built-in'
    }

    environment {
        CONTAINER_REPO = '138465306868.dkr.ecr.eu-west-3.amazonaws.com/devops/go-server'
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
                    --destination ${CONTAINER_REPO}:latest \
                    --destination ${CONTAINER_REPO}:${TAG}
                '''
            }
        }
        stage('Update image tag in repo manifest') {
            steps {
                sh '''
                    HEAD_COMMIT=$(git rev-parse --short HEAD)
                    TAG=$HEAD_COMMIT-$BUILD_NUMBER

                    kubectl patch --local \
                        -f k8s/goserver.yml \
                        -p """{"spec":{"template":{"spec":{"containers":[{"name":"goserver-container", "image":"${CONTAINER_REPO}:${TAG}"}]}}}}""" \
                        -o yaml > ./k8s/goserver.yml.tmp
                        
                     mv ./k8s/goserver.yml.tmp ./k8s/goserver.yml
                     
                     git add ./k8s/goserver.yml
                     git commit -m "Jenkins image update to tag ${TAG}"
                     git push
                '''
            }
        }
    }
}
