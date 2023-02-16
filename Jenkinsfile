pipeline {
    agent any

    stages {
        stage("Infrastructure"){
            steps {
                withAWS(credentials: 'aws-access-key', region: 'eu-west-1') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage("Deployment"){
            steps {
                dir('ansible') {
                    sshagent(['ssh_amazon']) {
                        sh 'ansible-playbook -i aws_ec2.yml ec2-dockerconfig.yml'
                    }
                }
            }
        }
    }
}