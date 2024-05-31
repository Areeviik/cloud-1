layer_metadata = {
  environment = "infrastructure"
  layer       = "000-base"
  project     = "42-cloud-1"
}

aws = {
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b"]
}

pem_path = "./origin_42_cloud_1.pem"
