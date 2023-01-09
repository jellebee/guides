terraform {
  //Do not forget to login for the remote backend using //Terraform Login
  backend "remote" {
    hostname = "app.terraform.io"

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
provider "aws" {
  #Default region AWS Frankfurt (EU-Central-1)
  region     = "eu-central-1"
  access_key = "youraccesskey"
  secret_key = "youraccesskey"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.s3.s3name

  tags = {
    name = "MyBucket"
  }
}

resource "aws_s3_bucket" "mylogsbucket" {
  bucket = var.s3.s3logsname

  tags = {
    name = "MyLogsBucket"
  }
}

resource "aws_s3_bucket_acl" "mybucket_acl" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = var.s3.bucketacl
}

resource "aws_s3_bucket_acl" "mylogsbucket_acl" {
  bucket = aws_s3_bucket.mylogsbucket.id
  acl    = var.s3.logbucketacl
}
