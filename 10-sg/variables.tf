variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_desc" {
  default = "create security group for bastion host"
}

variable "backend_alb_sg_name" {
  default = "bastion_backend_alb"
}

variable "backend_alb_sg_desc" {
  default = "create security group for backend alb"
}

variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_desc" {
  default = "create security group for frontend"
}

variable "vpn_sg_name" {
  default = "vpn"
}

variable "vpn_sg_desc" {
  default = "create security group for vpn"
}

