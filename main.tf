terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "vpc_creation" {
  source = "./modules/vpc-ec2-module"

  vpc_name                   = "test-vpc"
  private_subnet             = false
  ec2_instance_public_access = true
  server_port                = 80
}

output "public_ip" {
  value = module.vpc_creation.public_ip
}

