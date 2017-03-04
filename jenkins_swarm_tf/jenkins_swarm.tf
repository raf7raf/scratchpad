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

resource "aws_network_interface" "master_public_nic" {
    subnet_id = "${aws_subnet.public_a.id}"
    private_ips = ["10.0.0.50"]
    security_groups = ["${aws_security_group.web.id}"]
    attachment {
        instance = "${aws_instance.test.id}"
        device_index = 1
    }
}

resource "aws_network_interface" "master_priv_nic" {
    subnet_id = "${aws_subnet.public_a.id}"
    private_ips = ["10.0.0.50"]
    security_groups = ["${aws_security_group.web.id}"]
    attachment {
        instance = "${aws_instance.test.id}"
        device_index = 1
    }
}

resource "aws_network_interface" "slave_nic${count.index}" {
    subnet_id = "${aws_subnet.public_a.id}"
    private_ips = ["10.0.0.50"]
    security_groups = ["${aws_security_group.web.id}"]
    attachment {
        instance = "${aws_instance.test.${count.index}}"
        device_index = 1
    }
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

  # https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu
  provisioner "remote-exec" {
      inline = [
      "sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update",
      "sudo apt-get install jenkins"
      ]
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
  provisioner "remote-exec" {
        inline = [
        "wget -O ~/swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.3/swarm-client-3.3.jar",
	"java -master http://master.public:dns:8080 -username ${var.jenkins_user} -password  ${var.jenkins_pass} -name slave${count.index} -executors 2 -jar ~/swarm-client.jar"
        ]
    }
}
