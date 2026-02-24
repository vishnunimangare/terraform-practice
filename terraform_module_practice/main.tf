provider "aws" {
  region = "us-east-1"
}
module "ec2_instance" {
  source = "./module/ec2_instance"
  ami_value = "ami-0f3caa1cf4417e51b"
  instance_type_value = "t3.micro"
  subnet_id_value = "subnet-061d16da876e4db91"
}