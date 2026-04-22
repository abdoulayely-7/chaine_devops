pipeline {
    agent any

    tools {
        nodejs 'NodeJS-22'
    }

    environment {
        DOCKER_IMAGE = 'chaine_devops'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // 👇 ICI tu ajoutes le clean
        stage('Clean Workspace') {
            steps {
                sh '''
                    rm -rf node_modules
                    rm -rf package-lock.json
                    npm cache clean --force
                '''
            }
        }

        stage('Install') {
            steps {
                sh '''
                    rm -rf node_modules package-lock.json
                    npm cache clean --force
                    npm install --legacy-peer-deps
                '''
            }
        }

        stage('Test') {
            steps {
                sh 'npm run test'
            }
        }

        stage('Build React') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }
    }
}