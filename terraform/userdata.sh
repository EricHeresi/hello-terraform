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

