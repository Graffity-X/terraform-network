
terraform {
  required_version = ">= 0.12"
}


provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "kazuki.matsumoto"
  region                  = "ap-southeast-2"
}

terraform {
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "kazuki.matsumoto"
    bucket                  = "besides-terraform-back"
    key                     = "ap-southeast-2/network-prod/terraform.tfstate"
    region                  = "ap-southeast-2"
  }
}