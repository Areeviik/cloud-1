##########################################################
# Application Load Balancer
##########################################################

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.8.0"

  name = local.resource_prefix

  load_balancer_type         = "application"
  vpc_id                     = data.aws_vpc.vpc.id
  subnets                    = concat([data.aws_subnet.public1.id], [data.aws_subnet.public2.id])
  drop_invalid_header_fields = true
  enable_deletion_protection = false
  security_group_ingress_rules = {
    all_http = {
      description = "Allow all HTTP web traffic"
      from_port   = 80
      to_port     = 80
      ip_protocol = "TCP"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      description = "Allow all HTTPS web traffic"
      from_port   = 443
      to_port     = 443
      ip_protocol = "TCP"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all_outbound = {
      description = "Allow all outbound traffic"
      ip_protocol = "-1" // all protocols
      cidr_ipv4   = data.aws_vpc.vpc.cidr_block
    }
  }
  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port            = "443"
        protocol        = "HTTPS"
        status_code     = "HTTP_301"
        certificate_arn = module.acm.acm_certificate_arn
      }
      forward = {
        target_group_key = "web-app"
      }
      rules = {
        redirect-web-app = {
          tags = {
            "Name" = "redirect-to-web"
          }
          actions = [
            {
              type             = "forward"
              target_group_key = "web-app"
            }
          ]
          conditions = [{
            host_header = {
              values = ["value"]
            }
          }]
        }
      }
    }
  }

  target_groups = {
    web-app = {
      name_prefix = "web"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"

      health_check = {
        enabled             = true
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
      target_id = module.ec2_instance["web-app"].id
    }
  }
  depends_on = [module.ec2_instance, module.acm]
}

##########################################################
# Create EC2 instances
##########################################################

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  for_each = var.instances

  name                        = "${local.resource_prefix}-${each.key}"
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = each.value.instance_type
  availability_zone           = var.aws.azs[0]
  subnet_id                   = data.aws_subnet.public1.id //need to clarify
  vpc_security_group_ids      = [data.aws_security_group.http.id, data.aws_security_group.ssh.id]
  associate_public_ip_address = true
  key_name                    = local.resource_prefix
  monitoring                  = true
}

# resource "aws_ebs_volume" "web-volume" {
#   availability_zone = module.ec2_instance["web-app"].availability_zone
#   size              = var.instances["web-app"].volume_size
# }

# resource "aws_volume_attachment" "web-app" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.web-volume.id
#   instance_id = module.ec2_instance["web-app"].id
# }

##########################################################
# Route53 configuration
##########################################################

module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.11.1"

  zones = {
    "${var.dns_zone}" = {
      comment = "${var.dns_zone} (${var.layer_metadata.environment})"
    }
  }
}

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "2.11.1"

#   zone_name = keys(module.zones.route53_zone_zone_id)[0]

#   records = [
#     {
#       name = var.dns_zone
#       type = "A"
#       alias = {
#         name                   = module.alb.dns_name
#         zone_id                = module.zones.route53_zone_zone_id[var.dns_zone]
#         evaluate_target_health = false
#       }
#     }
#   ]

#   depends_on = [module.zones]
# }

##########################################################
# Create ACM Certificate
##########################################################

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  domain_name = var.dns_zone
  subject_alternative_names = [
    "*.${var.dns_zone}",
  ]

  validation_method   = "DNS"
  wait_for_validation = false

  create_route53_records = false
  zone_id                = module.zones.route53_zone_zone_id[var.dns_zone]
  depends_on             = [module.zones]
}
