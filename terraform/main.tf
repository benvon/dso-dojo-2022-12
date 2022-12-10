terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "aws_vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "dso-dojo-2022-12-bv"
    cidr = "10.99.0.0/16"
    create_igw = true
    azs = ["us-west-1a", "us-west-1b", "us-west-1c"]
    public_subnets = ["10.99.66.0/24", "10.99.99.0/24", "10.99.33.0/24"]
    private_subnets = ["10.99.11.0/24", "10.99.22.0/24", "10.99.44.0/24"]
    enable_nat_gateway = true
  
}

resource "aws_s3_bucket" "remote_backend_storage" {
  bucket = "dso-dojo-2022-12-bv-terraform-state"
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_backend_storage.id
  //enabled = true
  versioning_configuration {
    
  }
}

resource "aws_dynamodb_table" "remote_backend_lock" {
  name           = "dso-dojo-2022-12-bv-terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

