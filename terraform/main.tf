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
  count = var.instance_count
  ami           = "ami-0b752bf1df193a6c4"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0dd37ba3dac470b30"
  key_name      = "clave-lucatic"
  vpc_security_group_ids = [
    "sg-0194696b9502d969d",
  ]
  tags = {
    Name = var.instance_name
    APP  = var.instance_app_name
  }
}