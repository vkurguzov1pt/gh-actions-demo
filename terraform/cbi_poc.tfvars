vpc = {
  name           = "airflow-vpc",
  cidr           = "192.168.0.0/22",
  azs            = "us-east-1b,us-east-1c"
  public_subnets = "192.168.1.0/24,192.168.2.0/24"
}
