##########################################################
# VPC
##########################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = local.resource_prefix

  cidr           = var.vpc.cidr_block
  azs            = var.aws.azs
  public_subnets = var.vpc.public_subnets
  public_subnet_tags = {
    Name = "Public subnet"
  }
  private_subnets = var.vpc.private_subnets
  private_subnet_tags = {
    Name = "Private subnet"
  }
  # map_public_ip_on_launch = true
  # enable_nat_gateway   = true
}

##########################################################
# Security Groups
##########################################################

module "sg_http" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "${local.resource_prefix}-http"
  description = "Security group for web servers"

  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = var.vpc.cidr_block
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = join(",", var.vpc.private_subnets)
    }
  ]
  tags = {
    Name = "HTTP access"
  }
}

module "sg_ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "${local.resource_prefix}admin_access"
  description = "Security group for SSH access"

  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp",
      cidr_blocks = join(",", var.vpc.private_subnets)
    }
  ]

  tags = {
    Name = "SSH access"
  }
}
