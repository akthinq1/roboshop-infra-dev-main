resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project_name}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "backend_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/backend_sg_id"
  type  = "String"
  value = module.backend_alb.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project_name}/${var.environment}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
}

resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "/${var.project_name}/${var.environment}/frontend_sg_id"
  type  = "String"
  value = module.frontend.sg_id
}

resource "aws_ssm_parameter" "mongodb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/mongodb_sg_id"
  type  = "String"
  value = module.mongodb.sg_id
}

resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${var.project_name}/${var.environment}/mysql_sg_id"
  type  = "String"
  value = module.mysql.sg_id
}

resource "aws_ssm_parameter" "redis_sg_id" {
  name  = "/${var.project_name}/${var.environment}/redis_sg_id"
  type  = "String"
  value = module.redis.sg_id
}

resource "aws_ssm_parameter" "rabbitmq_sg_id" {
  name  = "/${var.project_name}/${var.environment}/rabbitmq_sg_id"
  type  = "String"
  value = module.rabbitmq.sg_id
}

resource "aws_ssm_parameter" "catalogue_sg_id" {
  name  = "/${var.project_name}/${var.environment}/catalogue_sg_id"
  type  = "String"
  value = module.catalogue.sg_id
}

resource "aws_ssm_parameter" "user_sg_id" {
  name  = "/${var.project_name}/${var.environment}/user_sg_id"
  type  = "String"
  value = module.user.sg_id
}

resource "aws_ssm_parameter" "cart_sg_id" {
  name  = "/${var.project_name}/${var.environment}/cart_sg_id"
  type  = "String"
  value = module.cart.sg_id
}

resource "aws_ssm_parameter" "shipping_sg_id" {
  name  = "/${var.project_name}/${var.environment}/shipping_sg_id"
  type  = "String"
  value = module.shipping.sg_id
}

resource "aws_ssm_parameter" "payment_sg_id" {
  name  = "/${var.project_name}/${var.environment}/payment_sg_id"
  type  = "String"
  value = module.payment.sg_id
}

resource "aws_ssm_parameter" "frontend_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/frontend_alb_sg_id"
  type  = "String"
  value = module.frontend_alb.sg_id
}

