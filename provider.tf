terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2" 
  access_key = "Please Input your AWS Access Key"
  secret_key = "Please Input your AWS Secret Key"
}