data "terraform_remote_state" "common" {
  backend = "s3"
  # varはterraform.tfvarsを呼ぶ(ここのむきさきはcommonなので、統一的に)
  config = {
    "shared_credentials_file" = var.aws_credentials_path
    "profile"                 = var.aws_credentials_profile_name
    "bucket"                  = var.s3_remote_state_bucket
    "key"                     = var.s3_remote_state_key # これはS3のkey
    "region"                  = var.region
  }
}