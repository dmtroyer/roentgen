provider "aws" {
  region = "us-east-2"
}

data "aws_region" "current" {}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "tls_private_key" "private_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "terraKey"       # Create "myKey" to AWS!!
  public_key = tls_private_key.private_key.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.private_key.private_key_openssh
  sensitive = true
}

#Create and bootstrap EC2 in us-east-1
# resource "aws_instance" "ec2-vm" {
#   ami                         = data.aws_ssm_parameter.linuxAmi.value
#   instance_type               = "t3.micro"
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.sg.id]
#   subnet_id                   = aws_subnet.public_subnet.id
#   key_name                    = aws_key_pair.key_pair.key_name
#   tags = {
#     Name = "${terraform.workspace}-ec2"
#   }
# }
