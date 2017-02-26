# Provision Jenkins swarm in AWS with designated number of slaves.
# Add all instances to custom VPC and enable connectivity between nodes

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block = "10.1.1.0/24"
}

resource "aws_instance" "master" {
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  count = 1
}

resource "aws_instance" "slave" {
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  count = 3
}
