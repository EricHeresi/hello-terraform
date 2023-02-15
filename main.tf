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
  provisioner "file" {
    source      = "userdata.sh"
    destination = "/tmp/userdata.sh"
    connection {
      type = "ssh"
      user = "ec2-user"
      host = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/userdata.sh",
      "sudo /tmp/userdata.sh",
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      host = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "cd hello2048",
      "docker-compose pull",
      "docker-compose up -d",
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      host = self.public_ip
    }
  }
}