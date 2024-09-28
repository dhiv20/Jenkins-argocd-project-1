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
                    url: 'https://github.com/dhiv20/Jenkins-argocd-project-1.git',
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
                    url: 'https://github.com/dhiv20/Jenkins-argocd-project-1-deployments.git',
                    branch: 'master'
            }
        }

        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                    withCredentials([gitUsernamePassword(credentialsId: 'github-login')]) {
                        sh '''
                        cat deploy.yaml
                        EXISTING_TAG=$(grep 'image: d2bdocker/cicd-e2e:' deploy.yaml | awk -F ':' '{print $3}')
                        sed -i "s|image: d2bdocker/cicd-e2e:${EXISTING_TAG}|image: d2bdocker/cicd-e2e:${BUILD_NUMBER}|g" deploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git config --global user.email "divy.bhatnagar@outlook.com"
                        git config --global user.name "Divye-Automatic"
                        git commit -m "Updated the deploy yaml | Jenkins Pipeline"
                        git remote -v
                        git push 'https://github.com/dhiv20/Jenkins-argocd-project-1-deployments.git' HEAD:master
                        '''
                    }
                }
            }
        }
    }
}
