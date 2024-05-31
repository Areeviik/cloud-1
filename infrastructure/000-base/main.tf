##########################################################
# TLS key generation
##########################################################

module "tls" {
  source = "../../modules/tls"

  # key name
  key_pair_name = local.resource_prefix
  # Save .pem file locally
  pem_path = var.pem_path
}
