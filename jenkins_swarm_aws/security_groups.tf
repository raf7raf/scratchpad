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
