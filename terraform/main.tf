terraform {
  backend "s3" {
    bucket    = "terraform-state-alvaronl"
    key       = "cloudfront-s3-staticsite/terraform.tfstate"
    region    = "eu-south-2"
    dynamodb_table = "terraform-state-locking"
    encrypt   = true
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

#Input vars
variable "input_hosted_zone_id" {
  description = "Input the domain hosted zone id"
  type        = string
}

variable "input_cert_arn" {
  description = "Input the generated certificated in ACM"
  type        = string
}

# Main deployment for a site.
module "main-deployment" {
  source = "./modules"

  ## storage.tf variables
  bucketname    = "cloudfront-s3-staticsite-alvaronl-com"
  html_path     = "../html/"
  bucket_tags   = {
    Name = "Cloudfront-alvaronl-com" 
    Environment = "Testing"
  }

  ## cloudfront.tf variables
  domain          = "alvaronl.com"
  regionname      = "eu-south-2" # Set same region as provider
  hosted_zone_id  = var.input_hosted_zone_id
  cert_arn        = var.input_cert_arn

  cloudfront_tags = {
    Name = "Cloudfront-alvaronl-com" 
    Environment = "Testing"
  }
}