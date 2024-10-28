terraform {
  backend "s3" {
    bucket = "terraform-state-alvaronl"
    key = "cloudfront-s3-staticsite/terraform.tfstate"
    region = "eu-south-2"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

  provider "aws" {
  region = "eu-south-2"
}

# Main deployment for a site.
module "main-deployment" {
  source = "./modules"

##Mandatory variables
hosted_zone_id = ""
cert_arn = ""

## storage.tf variables
bucketname = "cloudfront-s3-staticsite-alvaronl-com"
html_path = "../html/"
bucket_tags = {
    Name = "alvaronl.com" 
    Environment = "Testing"
}

## cloudfront.tf variables
domain = "cloudfront-s3-staticsite.alvaronl.com"
regionname = "eu-south-2" # Set same region as provider
}