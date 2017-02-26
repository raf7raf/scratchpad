variable "aws_region" {
  description = "Create swarm in designated region"
  default     = "eu-west-1"
}

variable "aws_amis" {
  description = "Vanilla Ubuntu 14.04 LTS AMI"
  default = {
    "eu-west-1" = "ami-a192bad2"
  }
}
