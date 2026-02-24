terraform {
  backend "s3" {
    bucket = "terraform-remote-backend-2202"
    region = "us-east-1"
    key = "vishnu/terraform.tfstate"
  }
}