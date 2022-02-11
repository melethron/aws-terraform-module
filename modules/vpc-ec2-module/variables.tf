variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "test"
}

variable "private_subnet" {
  description = "Should private subnet be created"
  default     = true
}

variable "ec2_name" {
  description = "ec2 instance name"
  default     = "nginx"
}

variable "ec2_instance_type" {
  description = "Specify EC2 instance type"
  default     = "t2.micro"
}

variable "ec2_instance_public_access" {
  description = "Specify if EC2 instance will have public ip"
}

variable "server_port" {
  description = "Port to open"
  type        = number

}
