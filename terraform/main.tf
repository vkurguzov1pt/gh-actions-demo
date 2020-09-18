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

resource "aws_instance" "ec2_runner" {
  instance_type          = "t3.micro"
  user_data              = data.template_file.user_data.rendered
  ami                    = data.aws_ami.amazon_linux.id
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = ["sg-03ee1a125a9791874"]
  key_name               = "airflow-key"
  monitoring             = false

  tags = {
    "Name" = join("-", ["gh-demo", "ec2-runner"])
  }
}


