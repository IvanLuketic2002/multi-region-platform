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
# --- HEALTH CHECK ZA FRANKFURT ---
resource "aws_route53_health_check" "primary" {
  ip_address        = module.ec2_primary.public_ip
  port              = 8000
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3" # Ako 3 puta za redom ne odgovori, smatra se da je pao
  request_interval  = "30"

  tags = {
    Name = "${var.environment}-health-check-primary"
  }
}

# --- HEALTH CHECK ZA PARIZ ---
resource "aws_route53_health_check" "secondary" {
  ip_address        = module.ec2_secondary.public_ip
  port              = 8000
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "${var.environment}-health-check-secondary"
  }
}
