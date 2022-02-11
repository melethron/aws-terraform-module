# CREATING VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.vpc_name}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

#CREATING GATEWAY FOR PUBLIC SUBNET
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gateway-${terraform.workspace}"
  }
}

#CREATING PUBLIC SUBNET
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1c"

  tags = {
    Name        = "${var.vpc_name}-public-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

#TODO ROUTES FOR PUBLIC SUBNET THROUGH GATEWAY
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "public-route-for-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

#amazon-linux-extras install nginx1

#CREATING PRIVATE SUBNET
resource "aws_subnet" "private_subnet" {
  count                   = var.private_subnet ? 1 : 0
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1c"

  tags = {
    Name        = "${var.vpc_name}-private-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
