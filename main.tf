terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
#####################################################################################
# Create a VPC
resource "aws_vpc" "testing" {
  cidr_block = "10.0.0.0/24"
  tags = {
    "Name" = "elram-naim-dev-vpc"
  }
}
resource "aws_subnet" "Subnet_Web" {
  vpc_id     = aws_vpc.testing.id
  cidr_block = "10.0.0.0/27"

  tags = {
    Name = "elram-naim-k8s-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.testing.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.testing.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


