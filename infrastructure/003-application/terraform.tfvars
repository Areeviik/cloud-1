layer_metadata = {
  environment = "staging"
  layer       = "003-application"
  project     = "42-cloud-1"
}

aws = {
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b"]
}

instances = {
  web-app = {
    name          = "web-app"
    instance_type = "t2.micro"
    volume_size   = 0
  }
}

dns_zone = "shinecosucan.duckdns.org"
