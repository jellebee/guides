terraform {
  //Do not forget to login for the remote backend using Terraform Login in the terminal and having tha workspace set as stated below.
  //This will allow you to use a remote backend. If this is not  your preference please remove the backend block.
  backend "remote" {
    organization = "MyCompany"

    workspaces {
      name = "Production"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
//Default Provider AWS
provider "aws" {
  region     = "eu-central-1"
  //default region will be EU Central 1 (Ireland)
  access_key = "youraccesskey"
  secret_key = "yoursecretkey"
}


resource "aws_vpc" "MyCompany_VPC" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name               = "MyCompany_VPC"
    CompanyName        = var.Global.CompanyName
    CompanyAbbrivation = var.Global.CompanyAbbrivation
    Type               = var.VPC.typetag
    Environment        = var.Global.Environment
    Managed            = var.Global.Managed
  }
}
resource "aws_subnet" "MyCompany_Public" {
  vpc_id            = aws_vpc.MyCompany_VPC.id
  cidr_block        = "10.1.16.0/24"
  availability_zone = var.Global.Availabilityzone

  tags = {
    Name               = "MyCompany_Public"
    CompanyName        = var.Global.CompanyName
    CompanyAbbrivation = var.Global.CompanyAbbrivation
    Type               = var.Subnet.typetag
    Environment        = var.Global.Environment
    Managed            = var.Global.Managed
  }
}
resource "aws_subnet" "MyCompany_Private" {
  vpc_id            = aws_vpc.MyCompany_VPC.id
  cidr_block        = "10.1.222.0/24"
  availability_zone = var.Global.Availabilityzone

  tags = {
    Name               = "MyCompany_Private"
    CompanyName        = var.Global.CompanyName
    CompanyAbbrivation = var.Global.CompanyAbbrivation
    Type               = var.Subnet.typetag
    Environment        = var.Global.Environment
    Managed            = var.Global.Managed
  }
}
resource "aws_subnet" "MyCompany_PrivateAZ2" {
  vpc_id            = aws_vpc.MyCompany_VPC.id
  cidr_block        = "10.1.223.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name               = "MyCompany_PrivateAZ2"
    CompanyName        = var.Global.CompanyName
    CompanyAbbrivation = var.Global.CompanyAbbrivation
    Type               = var.Subnet.typetag
    Environment        = var.Global.Environment
    Managed            = var.Global.Managed
  }
}
resource "aws_network_interface" "MyCompany_netint_Priv" {
  subnet_id   = aws_subnet.MyCompany_Private.id
  private_ips = ["10.1.222.10"]

  tags = {
    Name               = "MyCompany_netint_Priv"
    CompanyName        = var.Global.CompanyName
    CompanyAbbrivation = var.Global.CompanyAbbrivation
    Type               = var.NetworkInterface.typetag
    Environment        = var.Global.Environment
    Managed            = var.Global.Managed
  }
}
resource "aws_security_group" "MyCompany_PublicSG" {
  name        = "MyCompany_SG_PublicSG"
  description = "This is the only public security group of MyCompany"
  vpc_id      = aws_vpc.MyCompany_VPC.id

  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  // To Allow Port 443 Transport
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "MyCompany_AuroraSG" {
  name        = "aurora-security-group"
  description = "This is the only Aurora Security Group"
  vpc_id      = aws_vpc.MyCompany_VPC.id
  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "MyCompany-EC2" {
  ami                         = var.EC2.Ami
  instance_type               = var.EC2.Instancetype
  subnet_id                   = aws_subnet.MyCompany_Public.id
  associate_public_ip_address = true


  vpc_security_group_ids = [
    aws_security_group.MyCompany_PublicSG.id
  ]
  root_block_device {
    delete_on_termination = false
    volume_size           = 30
    volume_type           = "gp2"
  }
  tags = {
    Name        = "MyCompany-EC2"
    Environment = var.Global.Environment
    OS          = "UBUNTU"
    Managed     = var.Global.Managed
  }

  depends_on = [aws_security_group.MyCompany_PublicSG]
}
resource "aws_db_subnet_group" "aurorasubnetgroup" {
  name       = "aurorasubnetgroup"
  subnet_ids = [aws_subnet.MyCompany_Private.id, aws_subnet.MyCompany_PrivateAZ2.id]

  tags = {
    Name = "MyCompany Aurora DB Subnet Group"
  }
}
resource "aws_rds_cluster" "ServerlessClust" {
  cluster_identifier   = "serverlessclust"
  engine               = "aurora-postgresql"
  engine_mode          = "provisioned"
  engine_version       = "13.7"
  database_name        = "MyCompany_database"
  //Please setup your own master user (default psqladmin)
  master_username      = "psqladmin"
  //Please setup your own masterpw
  master_password      = "yourmasterpassword"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.aurorasubnetgroup.id
  vpc_security_group_ids = [
    aws_security_group.MyCompany_AuroraSG.id
  ]

  serverlessv2_scaling_configuration {
    max_capacity = var.Aurora.max_capacity
    min_capacity = var.Aurora.min_capacity
  }
}
resource "aws_rds_cluster_instance" "ServerlessClust" {
  cluster_identifier   = aws_rds_cluster.ServerlessClust.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.ServerlessClust.engine
  engine_version       = aws_rds_cluster.ServerlessClust.engine_version
  db_subnet_group_name = aws_db_subnet_group.aurorasubnetgroup.id
}
