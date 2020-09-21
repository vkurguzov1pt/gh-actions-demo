module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr           = var.vpc["cidr"]
  name           = var.vpc["name"]
  azs            = split(",", var.vpc["azs"])
  public_subnets = split(",", var.vpc["public_subnets"])
}

data "aws_ami" "amazon_linux" {
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  most_recent = true
}

data "template_file" "user_data" {
  template = "${file("user-data.sh.tpl")}"
  vars = {
    github_token = var.github_token
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["146.120.13.77/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_victor"
  }
}

resource "aws_instance" "ec2_runner" {
  instance_type          = "m5a.xlarge"
  user_data              = data.template_file.user_data.rendered
  ami                    = data.aws_ami.amazon_linux.id
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = "airflow-key"
  monitoring             = false

  root_block_device {
    volume_size = 60
  }

  tags = {
    "Name" = join("-", ["gh-demo", "ec2-runner"])
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2_runner.id
  allocation_id = aws_eip.app_eip.id
}

resource "aws_eip" "app_eip" {
  vpc = true
}



