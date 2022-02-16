terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.1"
     }
  }
  backend "s3" {
    bucket = "terraform-state-file-2022"
    key = "state-file"
    region = "ap-south-1"
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
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Infravpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

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
  ami = "ami-0c6615d1e95c98aca"
  instance_type = "t2.micro"
  #count=2
  for_each = toset([ "1","2" ])
  tags = {
    "Name" = "server-${each.key}"
  }
}
