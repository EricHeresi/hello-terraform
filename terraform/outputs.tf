output "instance_ids" {
  description = "ID of the EC2 Instances"
  value       = [aws_instance.app_server.id]
}

output "instance_public_ips" {
  description = "Public IP address of the EC2 Instances"
  value       = [aws_instance.app_server.public_ip]
}