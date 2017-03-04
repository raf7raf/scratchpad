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
