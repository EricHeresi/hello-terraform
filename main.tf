terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b752bf1df193a6c4"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0dd37ba3dac470b30"
  key_name      = "clave-lucatic"
  vpc_security_group_ids = [
    "sg-0194696b9502d969d",
  ]
  tags = {
    Name = var.instance_name
    APP  = "vue2048"
  }
  user_data = <<EOH
  #!/bin/bash
  amazon-linux-extras install -y docker
  service docker start
  usermod -a -G docker ec2-user
  pip3 install docker-compose
  mkdir /home/ec2-user/hello2048
  cd /home/ec2-user/hello2048
  wget https://raw.githubusercontent.com/EricHeresi/hello-2048/main/docker-compose.yml
  docker-compose pull
  docker-compose up -d
  chown -R ec2-user:ec2-user /home/ec2-user/hello2048
  EOH
}
