provider "aws" {
  region = "us-east-1"
  }

  resource "aws_instance" "remote_backend" {
    ami = "ami-0f3caa1cf4417e51b"
    instance_type = "t3.micro"
    subnet_id = "subnet-061d16da876e4db91"
  }