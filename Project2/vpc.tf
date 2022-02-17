terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.1"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-file-2022"
    key            = "state-file-feb-2022"
    region         = "ap-south-1"
    dynamodb_table = "state_store_table"
  }
}
provider "aws" {
  region = var.location
}
resource "aws_vpc" "Infravpc" {
  cidr_block = var.cidr
  tags = {
    Name = "Infra"
  }

}
resource "aws_subnet" "infra-subnet" {
  vpc_id     = aws_vpc.Infravpc.id
  cidr_block = var.cidr_subnet

  tags = {
    Name = "Infrasubnet"
  }
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Infravpc.id

  tags = {
    Name = "infraigw"
  }
}

resource "aws_route_table" "infra-rt" {
  vpc_id = aws_vpc.Infravpc.id
}

resource "aws_route" "infa-route" {
  route_table_id         = aws_route_table.infra-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

}

resource "aws_route_table_association" "infra-rt-association" {
  subnet_id      = aws_subnet.infra-subnet.id
  route_table_id = aws_route_table.infra-rt.id
}

resource "aws_security_group" "infra-sg" {
  name        = local.name
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Infravpc.id

  dynamic "ingress" {
    for_each = var.ports
    iterator = abc
    content {
      description = "TLS from VPC"
      from_port   = abc.value
      to_port     = abc.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.jenkinsimage.id
  instance_type = var.type
  #count=2
  for_each = toset(["1", "2"])
  tags = {
    "Name" = "server-${each.key}"
  }
  vpc_security_group_ids = [ aws_security_group.infra-sg.id ]
  subnet_id = aws_subnet.infra-subnet.id
}

locals {
  name = "allow_tls-${var.location}"
}


