provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "terraform" {
  key_name   = "terraform-demo"
  public_key = file("${path.module}/id_rsa.pub")
  }

resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_route_table" "terraform_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }
}
 resource "aws_route_table_association" "rt1" {
   subnet_id = aws_subnet.sub1.id
   route_table_id = aws_route_table.terraform_rt.id
 }

 resource "aws_security_group" "terraform_sg" {
   name = "web_sg"
   vpc_id = aws_vpc.terraform_vpc.id

   ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
    description = "All outbound"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
   tags = {
    Name = "web_sg"
   }
 }

resource "aws_instance" "terraform_server" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.terraform.key_name
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = file("${path.module}/id_rsa")   # <-- Use this
  host        = self.public_ip
}

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ec2-user/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo yum update -y",
      "sudo yum install -y python3-pip",
      "cd /home/ec2-user",
      "sudo pip3 install flask",
      "sudo python3 app.py"
    ]
  }
}

 

