provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "cbi-infra"
    key    = "github-actions-demo.tfstate"
    region = "us-east-1"
  }
}


