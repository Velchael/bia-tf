terraform {
  backend "s3" {
    bucket  = "bia-tf-vel"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "bia"
  }
}