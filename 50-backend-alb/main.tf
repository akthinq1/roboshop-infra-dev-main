module "backend_alb" {
  source   = "terraform-aws-modules/alb/aws"
  version  = "9.16.0"
  internal = true

  name                       = "${var.project_name}-${var.environment}-backend-alb"
  vpc_id                     = local.vpc_id
  subnets                    = local.private_subnet_ids
  create_security_group      = false # I have security group ready to attach
  security_groups            = [local.backend_sg_id]
  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-backend-alb"
    }
  )
}

# attach listener to alb

resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = module.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am listening from backend<h2>"
      status_code  = "200"
    }
  }
}


# create r53 record for dns alb url
resource "aws_route53_record" "backend_alb" {
  zone_id = var.zone_id
  # name    = "*.backend.${var.zone_name}"
  name    = "*.backend-dev.${var.zone_name}"
  type    = "A"

  alias {
    name                   = module.backend_alb.dns_name #get dns name from terraform alb module
    zone_id                = module.backend_alb.zone_id # zone id of ALB created in aws
    evaluate_target_health = true
  }
}