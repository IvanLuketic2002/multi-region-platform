terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primarni provajder (Frankfurt)
provider "aws" {
  region = var.primary_region
}

# Sekundarni provajder (Pariz)
provider "aws" {
  alias  = "paris"
  region = var.secondary_region
}

# --- PRIMARNI REGION (Frankfurt) ---
module "ec2_primary" {
  source = "./modules/ec2"

  aws_region    = var.primary_region
  environment   = var.environment
  vpc_cidr      = "10.0.0.0/16"
  subnet_cidr   = "10.0.1.0/24"
  instance_type = "t3.micro"
}

# --- SEKUNDARNI REGION (Pariz) ---
module "ec2_secondary" {
  source = "./modules/ec2"

  providers = {
    aws = aws.paris
  }

  aws_region    = var.secondary_region
  environment   = var.environment
  vpc_cidr      = "10.1.0.0/16"           
  subnet_cidr   = "10.1.1.0/24"
  instance_type = "t3.micro"
}
