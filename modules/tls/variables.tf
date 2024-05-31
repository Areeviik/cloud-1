variable "key_pair_name" {
  description = "Key pair name for ssh connect to the instances"
  type        = string
  default     = ""
}

variable "pem_path" {
  description = "Local directory where should be saved the generated .pem file"
  type        = string
  default     = "./"
}
