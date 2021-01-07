
terraform {
  required_version = ">= 0.12"
}
# 実行するIAMuserの情報
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "onosemoe" #shared_credentials_fileの[]の名前 どのuser使うか
  region                  = "ap-northeast-1"
}
# 構築した環境の内容をここでバージョン管理する（S3）
terraform {
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "onosemoe"
    bucket                  = "besides-terraform-back"
    key                     = "ap-northeast-1/network-testflight/terraform.tfstate" #保存先のフォルダ 
    region                  = "ap-northeast-1"
  }
}