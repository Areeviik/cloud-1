resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key_pair for AWS instances access
resource "aws_key_pair" "key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.pk.public_key_openssh

  # Save created ".pem" to local computer
  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > '${var.pem_path}'"
  }
}
