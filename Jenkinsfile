pipeline {
    agent any

    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'docker-login'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-login',
                    url: 'https://github.com/dhiv20/Jenkins-argocd-proj1.git',
                    branch: 'master'
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        def app = docker.build("d2bdocker/cicd-e2e:${BUILD_NUMBER}")
                        app.push()
                    }
                }
            }
        }

        stage('Checkout K8S manifest SCM') {
            steps {
                git credentialsId: 'github-login',
                    url: 'https://github.com/dhiv20/Jenkins-argocd-proj1.git',
                    branch: 'master',
                    path: '/deploy',
            }
        }

        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-login', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cd /deploy
                        cat deploy.yaml
                        sed -i "s/32/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
                        cd /
                        git add .
                        git commit -m "Updated the deploy yaml | Jenkins Pipeline"
                        git remote -v
                        git push https://github.com/dhiv20/Jenkins-argocd-proj1.git HEAD:master
                        '''
                    }
                }
            }
        }
    }
}
