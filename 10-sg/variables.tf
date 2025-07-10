variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "bastion_sg_name" {
  default = "bastion-sg"
}

variable "bastion_sg_desc" {
  default = "create security group for bastion host"
}

variable "backend_alb_sg_name" {
  default = "bastion_backend_alb-sg"
}

variable "backend_alb_sg_desc" {
  default = "create security group for backend alb"
}

variable "frontend_sg_name" {
  default = "frontend-sg"
}

variable "frontend_sg_desc" {
  default = "create security group for frontend"
}

variable "vpn_sg_name" {
  default = "vpn-sg"
}

variable "vpn_sg_desc" {
  default = "create security group for vpn"
}

variable "mongodb_sg_name" {
  default = "mongodb-sg"
}

variable "mongodb_sg_desc" {
  default = "create security group for mongodb"
}

variable "mysql_sg_name" {
  default = "mysql-sg"
}

variable "mysql_sg_desc" {
  default = "create security group for mysql"
}

variable "redis_sg_name" {
  default = "redis-sg"
}

variable "redis_sg_desc" {
  default = "create security group for redis"
}

variable "rabbitmq_sg_name" {
  default = "rabbitmq-sg"
}

variable "rabbitmq_sg_desc" {
  default = "create security group for rabbitmq"
}

variable "mongodb_ports_vpn" {
  default = [22, 27017]
}

variable "mysql_ports_vpn" {
  default = [22, 3306]
}

variable "redis_ports_vpn" {
  default = [22, 6379]
}

variable "rabbitmq_ports_vpn" {
  default = [22, 5672]
}

variable "monogodb_ports_bastion" {
  default = [22, 27017]
}

variable "mysql_ports_bastion" {
  default = [22, 3306]
}

variable "redis_ports_bastion" {
  default = [22, 6379]
}

variable "rabbitmq_ports_bastion" {
  default = [22, 5672]
}


variable "catalogue_sg_name" {
  default = "catalogue-sg"
}

variable "catalogue_sg_desc" {
  default = "create security group for catalogue"
}

variable "frontend_alb_sg_name" {
  default = "frontend-alb-sg"
}

variable "frontend_alb_sg_desc" {
  default = "create security group for frontend-alb"
}

variable "cart_sg_name" {
  default = "cart-sg"
}

variable "cart_sg_desc" {
  default = "create security group for cart"
}

variable "user_sg_name" {
  default = "user-sg"
}

variable "user_sg_desc" {
  default = "create security group for user"
}

variable "shipping_sg_name" {
  default = "shipping-sg"
}

variable "shipping_sg_desc" {
  default = "create security group for shipping"
}

variable "payment_sg_name" {
  default = "payment-sg"
}

variable "payment_sg_desc" {
  default = "create security group for payment"
}
