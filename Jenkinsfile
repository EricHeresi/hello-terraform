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
                sshagent(['ssh_amazon']) {
                    sh 'ansible-playbook -i ansible/aws_ec2.yml ansible/ec2-dockerconfig.yml'
                }
            }
        }
    }
}