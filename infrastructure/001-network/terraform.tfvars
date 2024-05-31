layer_metadata = {
  environment = "staging"
  layer       = "001-network"
  project     = "42-cloud-1"
}

aws = {
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b"]
}

vpc = {
  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.0.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.3.0/24"]
}

dns_zone = "value"
dns_name = "value"
