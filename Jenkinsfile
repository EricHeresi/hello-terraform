pipeline {
    agent any
    environment{
        GIT_USER = 'EricHeresi'
        GIT_PATH = 'ericheresi/hello-terraform'
    }
    options{
        timestamps()
    }
    stages {
        stage('Git Login'){
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]) {
                    sh 'echo $GIT_TOKEN | docker login ghcr.io -u ${GIT_USER} --password-stdin'
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
                    sh 'git push git@github.com:${GIT_PATH}.git --tags'
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
                    withAWS(credentials: 'aws-access-key', region: 'eu-west-1')  {
                        withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]) {
                            ansiColor('xterm') {
                                ansiblePlaybook(
                                    playbook: 'ec2-dockerconfig.yml',
                                    inventory: 'aws_ec2.yml',
                                    credentialsId: 'ssh_amazon',
                                    extras: '-v',
                                    colorized: true)
                            }
                        }
                    }            
                }
            }
        }
    }
}