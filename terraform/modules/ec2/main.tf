# AWS Key Pair - Registruje tvoj lokalni SSH ključ na AWS-u
resource "aws_key_pair" "deployer" {
  key_name   = "${var.environment}-deployer-key"
  public_key = file("~/.ssh/multi-region-key.pub")
}

# AWS VPC (Virtuelna privatna mreža za izolaciju resursa)
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc-${var.aws_region}"
  }
}

# Internet Gateway (omogućava našem VPC-u pristup internetu)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw-${var.aws_region}"
  }
}

# Javni Subnet unutar VPC-a
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${var.aws_region}"
  }
}

# Route Table (Pravila rutanja saobraćaja ka internetu)
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.environment}-route-table-${var.aws_region}"
  }
}

# Povezivanje Route Table-a sa Subnet-om
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

# Security Group (Zid zaštite - otvaramo samo portove 22 za SSH i 8000 za aplikaciju)
resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-sg-${var.aws_region}"
  description = "Allow SSH and App Port"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-sg-${var.aws_region}"
  }
}

# EC2 Instanca na kojoj će raditi naš Docker kontejner
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  # Skripta koja automatski instalira Docker čim se server upali
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              EOF

  tags = {
    Name = "${var.environment}-ec2-${var.aws_region}"
  }
}
