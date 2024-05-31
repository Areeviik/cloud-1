variable "layer_metadata" {
  description = <<-_EOF
	Metadata to be applied to all layer resources
	{
		project: Name of the project the resources belong to
		environment: Name of the project's environment (e.g. dev)
		layer: Name of the layer (e.g. 000-base etc)
	}
	_EOF
  type = object({
    project     = string
    environment = string
    layer       = string
  })
}

variable "aws" {
  description = "AWS specific variables"
  type = object({
    region = string
    azs    = list(string)
  })
}

variable "vpc" {
  description = "VPC specific variables"
  type = object({
    cidr_block      = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
}


variable "dns_zone" {
  description = "Domain name in route53"
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "Subdomain for root domain name in route53"
  type        = string
  default     = ""
}
