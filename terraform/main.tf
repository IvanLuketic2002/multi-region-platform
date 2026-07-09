terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Definisanje AWS provajdera za primarni region (Evropa)
provider "aws" {
  region = var.primary_region
}

# Pozivamo modul koji smo napisali da kreira resurse u Evropi
module "ec2_primary" {
  source        = "./modules/ec2"
  aws_region    = var.primary_region
  environment   = var.environment
  vpc_cidr      = "10.0.0.0/16"
  subnet_cidr   = "10.0.1.0/24"
  instance_type = "t3.micro"
  
  # Najnoviji Ubuntu 22.04 LTS AMI ID za eu-central-1 (Frankfurt)
  ami_id        = "ami-0084a47cc718c111a"
}
