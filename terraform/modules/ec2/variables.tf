variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "subnet_cidr" {
  type        = string
  description = "Subnet CIDR Block"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/prod)"
}

variable "ami_id" {
  type        = string
  description = "Ubuntu AMI ID za selektovani region"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Tip EC2 instance"
}

