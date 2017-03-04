# Provision Jenkins swarm in AWS with designated number of slaves.
# Add all instances to custom VPC and enable connectivity between nodes

provider "aws" {
  region = "${var.aws_region}"
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
