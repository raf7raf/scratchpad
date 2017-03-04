# Global variables

variable "aws_region" {
  description = "Create swarm in designated region"
  default     = "eu-west-1"
}

variable "aws_amis" {
  type = map
  description = "Vanilla Ubuntu 14.04 LTS AMI"
  default = {
    "eu-west-1" = "ami-a192bad2"
  }
}

variable "master_size" {
  type = string
  default = "t2.micro"	  # Recommended m4.large minimum for production usage
}

variable "slave_size" {
  type = string
  default = "t2.micro"  
}

variable "executor_map" {
  type = "map"

  default = {		# Recommended settings only.  BENCHMARK!
    t2.nano = "1"
    t2.micro = "2"
    t2.small = "2"
    t2.medium = "4"
    t2.large = "6"
    t2.xlarge = "8"
    t2.2xlarge = "16"
    m4.large = "4"
    m4.xlarge = "8"
    m4.2xlarge = "16"
  }
}

# Jenkins Swarm plugin configuration variables

variable "jenkins_user" {
  type    = "string"
  default = "wfarn"
}

variable "jenkins_pass" {
  type    = "string"
  default = "SyCaqjMuhJc6zTQu"
}

variable "swarm_jar_url" {
  type    = "string"
  default = "https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.3/swarm-client-3.3.jar"
}

# Jenkins configuration variables

variable "jenkins_key_url" {
  type    = "string"
  default = "https://pkg.jenkins.io/debian/jenkins-ci.org.key"
}

variable "jenkins_bin_url" {
  type    = "string"
  default = "http://pkg.jenkins.io/debian-stable"
}
