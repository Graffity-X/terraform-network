provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "onosemoe"
  region                  = "ap-northeast-1"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "onosemoe"
    bucket                  = "besides-terraform-back"
    key                     = "ap-northeast-1/network-common/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}