data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
}

resource "aws_instance" "web_server_public" {
  count         = var.ec2_instance_public_access ? 1 : 0
  instance_type = var.ec2_instance_type
  ami           = data.aws_ami.amazon_linux.id
  subnet_id     = aws_subnet.public_subnet.id
  user_data     = file("install_nginx.sh")

  tags = {
    Name        = "${var.vpc_name}-public-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "allow_port_public" {
  vpc_id      = aws_vpc.main.id
  name        = "web-server-sg-${terraform.workspace}"
  description = "some desc"
  ingress {
    description      = "Open port"
    from_port        = var.server_port
    to_port          = var.server_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Open port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-private-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.allow_port_public.id
  network_interface_id = aws_instance.web_server_public[0].primary_network_interface_id
}
