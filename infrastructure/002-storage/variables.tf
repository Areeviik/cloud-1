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
