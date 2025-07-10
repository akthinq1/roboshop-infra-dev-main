
module "bastion" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.bastion_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.bastion_sg_name}"
  sg_name = var.bastion_sg_name
  vpc_id  = local.vpc_id
}

# create sg rule for bastion host to allow for admins 
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

######################################################################

# a security group need for LB in private subnet to allow requests from bastion host
module "backend_alb" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.backend_alb_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.backend_alb_sg_name}"
  sg_name = var.backend_alb_sg_name
  vpc_id  = local.vpc_id
}

# backed ALB accepting connections from my bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  source_security_group_id = module.bastion.sg_id # sg_id is collected from bastion security group insted of bastion ec2 id
  security_group_id        = module.backend_alb.sg_id

}

# backend ALB accepting connections from my VPN host on port no 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# creating security group for VPN 
module "vpn" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.vpn_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.vpn_sg_name}"
  sg_name = var.vpn_sg_name
  vpc_id  = local.vpc_id
}

# create sg rules for vpn with port numbers ssh-22, https-443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type        = "ingress"
  from_port   = 943
  to_port     = 943
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type        = "ingress"
  from_port   = 1194
  to_port     = 1194
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id

}

#####################################################################

# create securty group for mongodb
module "mongodb" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.mongodb_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.mongodb_sg_name}"
  sg_name = var.mongodb_sg_name
  vpc_id  = local.vpc_id
}

# security group rules for mongodb
resource "aws_security_group_rule" "mongodb_vpn" {
  count     = length(var.mongodb_ports_vpn)
  type      = "ingress"
  from_port = var.mongodb_ports_vpn[count.index]
  to_port   = var.mongodb_ports_vpn[count.index]
  protocol  = "tcp"

  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id

}

resource "aws_security_group_rule" "mongodb_bastion" {
  count                    = length(var.monogodb_ports_bastion)
  type                     = "ingress"
  from_port                = var.monogodb_ports_bastion[count.index]
  to_port                  = var.monogodb_ports_bastion[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id        = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id        = module.mongodb.sg_id
}

######################################################################
# create securty group for mysql
module "mysql" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.mysql_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.mongodb_sg_name}"
  sg_name = var.mysql_sg_name
  vpc_id  = local.vpc_id
}

# security group rules for mysql

resource "aws_security_group_rule" "mysql_vpn_" {
  count     = length(var.mysql_ports_vpn)
  type      = "ingress"
  from_port = var.mysql_ports_vpn[count.index]
  to_port   = var.mysql_ports_vpn[count.index]
  protocol  = "tcp"

  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id

}

resource "aws_security_group_rule" "mysql_bastion" {
  count                    = length(var.mysql_ports_bastion)
  type                     = "ingress"
  from_port                = var.mysql_ports_bastion[count.index]
  to_port                  = var.mysql_ports_bastion[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mysql.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id        = module.mysql.sg_id
}

#############################################################################

# create securty group for redis
module "redis" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.redis_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.mongodb_sg_name}"
  sg_name = var.redis_sg_name
  vpc_id  = local.vpc_id
}

resource "aws_security_group_rule" "redis_vpn" {
  count     = length(var.redis_ports_vpn)
  type      = "ingress"
  from_port = var.redis_ports_vpn[count.index]
  to_port   = var.redis_ports_vpn[count.index]
  protocol  = "tcp"

  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_bastion" {
  count                    = length(var.redis_ports_bastion)
  type                     = "ingress"
  from_port                = var.redis_ports_bastion[count.index]
  to_port                  = var.redis_ports_bastion[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_user" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id        = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id        = module.redis.sg_id
}

#####################################################################

# secuirty group for rabbitmq
# create securty group for rabbitmq
module "rabbitmq" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.rabbitmq_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.mongodb_sg_name}"
  sg_name = var.rabbitmq_sg_name
  vpc_id  = local.vpc_id
}

# secuirty group rules for rabbitmq
resource "aws_security_group_rule" "rabbitmq_vpn" {
  count     = length(var.rabbitmq_ports_vpn)
  type      = "ingress"
  from_port = var.rabbitmq_ports_vpn[count.index]
  to_port   = var.rabbitmq_ports_vpn[count.index]
  protocol  = "tcp"

  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_bastion" {
  count                    = length(var.rabbitmq_ports_bastion)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_bastion[count.index]
  to_port                  = var.rabbitmq_ports_bastion[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

#########################################################################

# create security groups for components and expose those with rules
# create securty group for catalogue
module "catalogue" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.catalogue_sg_desc
  sg_name        = var.catalogue_sg_name
  vpc_id         = local.vpc_id
}

# rules for catalogue sg
#Catalogue
resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.catalogue.sg_id
}

#########################################################################

# security group for cart
module "cart" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.cart_sg_desc
  sg_name        = var.cart_sg_name
  vpc_id         = local.vpc_id
}

# cart security group rules
resource "aws_security_group_rule" "cart_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.cart.sg_id
}

#####################################################################

# security group for user
module "user" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.user_sg_desc
  sg_name        = var.user_sg_name
  vpc_id         = local.vpc_id
}

# user security group rules
resource "aws_security_group_rule" "user_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "user_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "user_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.user.sg_id
}

#####################################################################

# security group for shipping
module "shipping" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.shipping_sg_desc
  sg_name        = var.shipping_sg_name
  vpc_id         = local.vpc_id
}

# security group rules for shipping
resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.shipping.sg_id
}

########################################################################

# security group for payment
module "payment" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.payment_sg_desc
  sg_name        = var.payment_sg_name
  vpc_id         = local.vpc_id
}

# secutity group rule for payment
resource "aws_security_group_rule" "payment_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.payment.sg_id
}

##########################################################################

# secuirty group for front end
module "frontend" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.frontend_sg_desc
  sg_name        = var.frontend_sg_name
  vpc_id         = local.vpc_id
}

# security group rules for frontend
# frontend to frontend_alb
resource "aws_security_group_rule" "frontend_frontend_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id        = module.frontend.sg_id
}

# frontend to vpn
resource "aws_security_group_rule" "frontend_vpn" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.frontend.sg_id
}

# frontend to bastion
resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.frontend.sg_id
}

###########################################################################

# create security group for forntend alb
module "frontend_alb" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.frontend_alb_sg_desc
  sg_name        = var.frontend_alb_sg_name
  vpc_id         = local.vpc_id
}

# create security group rules for front end alb 
#Frontend ALB http it is optional
resource "aws_security_group_rule" "frontend_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.backend_alb.sg_id
}

# frontend ALB https
resource "aws_security_group_rule" "frontend_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}


