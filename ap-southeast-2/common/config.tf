provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "kazuki.matsumoto"
  region                  = "ap-souteast-2"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "kazuki.matsumoto"
    bucket                  = "besides-terraform-back"
    key                     = "ap-souteast-2/network-common/terraform.tfstate"
    region                  = "ap-souteast-2"
  }
}