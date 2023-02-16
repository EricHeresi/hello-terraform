pipeline {
    agent any

    stages {
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
                            sh 'ansible-playbook -i aws_ec2.yml ec2-dockerconfig.yml'
                        }
                    }
                }
            }
        }
    }
}