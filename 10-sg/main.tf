module "frontend" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.frontend_sg_desc
  sg_name        = var.frontend_sg_name
  vpc_id         = local.vpc_id
}

module "bastion" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.bastion_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.bastion_sg_name}"
  sg_name        = var.bastion_sg_name
  vpc_id         = local.vpc_id
}

# a security group need for LB in private subnet to allow requests from bastion host
module "backend_alb" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.backend_alb_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.backend_alb_sg_name}"
  sg_name        = var.backend_alb_sg_name
  vpc_id         = local.vpc_id
}

# creating security group for VPN
module "vpn" {
  source         = "git::https://github.com/akthinq1/terraform-aws-sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_description = var.vpn_sg_desc
  # sg_name        = "${var.project_name}-${var.environment}-${var.vpn_sg_name}"
  sg_name        = var.vpn_sg_name
  vpc_id         = local.vpc_id
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

# backed ALB accepting connections from my bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  
  source_security_group_id = module.backend_alb.sg_id # sg_id is collected from bastion security group insted of bastion ec2 id
  security_group_id        = module.bastion.sg_id
  
}

# create sg rules for vpn with port numbers ssh-22, https-443, 1194, 943
resource "aws_security_group_rule" "vpn_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id # sg_id is collected from bastion security group insted of bastion ec2 id
}

resource "aws_security_group_rule" "vpn_https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id # sg_id is collected from bastion security group insted of bastion ec2 id
}

resource "aws_security_group_rule" "vpn_943" {
  type        = "ingress"
  from_port   = 943
  to_port     = 943
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id # sg_id is collected from bastion security group insted of bastion ec2 id
}

resource "aws_security_group_rule" "vpn_1194" {
  type        = "ingress"
  from_port   = 1194
  to_port     = 1194
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = module.vpn.sg_id # sg_id is collected from bastion security group insted of bastion ec2 id
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
