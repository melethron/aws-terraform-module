output "name" {
  description = "VPC name that created"
  value       = aws_vpc.main.tags.Name
}

output "public_ip" {
  description = "The public IP address assigned to the instance"
  value       = ["${aws_instance.web_server_public.*.public_ip}"]
}
