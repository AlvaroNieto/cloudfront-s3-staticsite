terraform {
  backend "s3" {
    bucket = "terraform-state-alvaronl"
    key = "s3-staticsite/terraform.tfstate"
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

#Deploy S3 and upload files
module "deployment-alvaronl.com" {
  source = "./modules"

  html_path = "../html/"  # Pass the variable to the module
}

#Configure cloud front