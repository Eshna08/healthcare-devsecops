pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Security Checks') {
            steps {
                sh '''
                    chmod +x security-check.sh
                    ./security-check.sh
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t healthcare-dashboard:build-${BUILD_NUMBER} .
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f healthcare-container || true
                    docker run -d --name healthcare-container \
                    -p 8085:80 healthcare-dashboard:build-${BUILD_NUMBER}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    sleep 3
                    curl -f http://localhost:8085
                '''
            }
        }
    }
}
