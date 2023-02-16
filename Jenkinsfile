pipeline {
    agent any

    stages {
        stage('Git Login'){
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]) {
                    sh 'echo $GIT_TOKEN | docker login ghcr.io -u EricHeresi --password-stdin'
                }
            }
        }
        stage('Image generation'){
            steps {
                dir("docker") {
                    sh 'docker-compose build'
                    sh 'VERSION_TAG=1.0.${BUILD_NUMBER} docker-compose build'
                    sh 'VERSION_TAG=1.0.${BUILD_NUMBER} docker-compose push'
                    sh 'docker-compose push'
                }
                sh 'git tag 1.0.${BUILD_NUMBER}'
                sshagent(['github-ssh']) {
                    sh 'git push git@github.com:EricHeresi/hello-terraform.git --tags'
                }
            }
        }
        stage("Infrastructure"){
            steps {
                dir('terraform') {
                    withAWS(credentials: 'aws-access-key', region: 'eu-west-1') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        stage("Deployment"){
            steps {
                dir('ansible') {
                    sshagent(['ssh_amazon']){
                        withAWS(credentials: 'aws-access-key', region: 'eu-west-1')  {
                            withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]) {
                                sh 'GHCR_TOKEN=$GIT_TOKEN ansible-playbook -i aws_ec2.yml -v ec2-dockerconfig.yml'
                            }
                        }
                    }
                }
            }
        }
    }
}