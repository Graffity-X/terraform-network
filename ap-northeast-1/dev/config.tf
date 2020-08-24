
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "kazuki.matsumoto"
  region                  = "ap-northeast-1"
}

terraform {
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "kazuki.matsumoto"
    bucket                  = "besides-terraform-back"
    key                     = "ap-northeast-1/dev/terraform.tfstate"
    region                  = "ap-northeast-1"
  }
}