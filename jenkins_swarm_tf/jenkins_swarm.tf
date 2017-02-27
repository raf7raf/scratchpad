# Provision Jenkins swarm in AWS with designated number of slaves.
# Add all instances to custom VPC and enable connectivity between nodes

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_vpc" "jenkins_swarm" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "jenkis_swarm" {
  vpc_id = "${aws_vpc.jenkins_swarm.id}"
  cidr_block = "10.0.0.0/16"
  availability_zone = "eu-west-1a"
}

resource "aws_security_group" "jenkins_master" {
  vpc_id = "${aws_vpc.jenkins_swarm.id}"
  name = "jenkins_master"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["${var.control_cidr}"]
  }

# Allow inbound connections to Jenkins Winstone webserver
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
  }
    
  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins_slave" {
  vpc_id = "${aws_vpc.jenkins_swarm.id}"
  name = "jenkins_slave"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["${var.control_cidr}"]
  }

  # Allow all outbound traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master" {
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  count = 1
  tags {
    Name = "jenkins_master"
    ansibleFilter = "jenkins_master"
    ansibleNodeType = "jenkins_master"
    ansibleNodeName = "jenkins_master"
  }

}

resource "aws_instance" "slave" {
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  count = 3
  tags {
    Name = "jenkins_slave-${count.index}"
    ansibleFilter = "jenkins_slave"
    ansibleNodeType = "jenkins_slave"
    ansibleNodeName = "jenkins_slave${count.index}"
  }
}
