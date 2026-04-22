pipeline {
    agent any
    tools {
        nodejs 'NodeJS-22'
    }
    environment {
        DOCKER_IMAGE = 'abdoulayely777/chaine_devops'
        DOCKER_TAG   = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install') {
            steps {
                sh '''
                    node --version
                    npm --version
                    # npm ci exige package-lock.json synchronisé
                    npm ci --prefer-offline || (rm -rf node_modules package-lock.json && npm install)
                '''
            }
        }

        stage('Test') {
            steps {
                // --run pour éviter le mode watch de Vitest en CI
                sh 'npm run test -- --run'
            }
        }

        stage('SonarCloud Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')])  {
                    sh '''
                        npx sonar-scanner \
                        -Dsonar.projectKey=chaine_devops \
                        -Dsonar.organization=abdoulayely-7 \
                        -Dsonar.sources=src \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.login=$SONAR_TOKEN
                    '''
                }
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

        stage('Trivy Scan') {
            steps {
                sh '''
                    docker run --rm \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy image \
                    --exit-code 1 \
                    --severity HIGH,CRITICAL \
                    ${DOCKER_IMAGE}:${DOCKER_TAG}
                '''
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker_chaine_devops',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        # Push version build
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}

                        # 👉 créer le tag latest
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest

                        # 👉 push latest
                        docker push ${DOCKER_IMAGE}:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Image construite: ${DOCKER_IMAGE}:${DOCKER_TAG}"
        }
        failure {
            echo "❌ Pipeline échoué — vérifier les logs"
        }
    }
}