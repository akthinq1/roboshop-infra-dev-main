locals {
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  backend_sg_id      = data.aws_ssm_parameter.backend_sg_id.value

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = true
  }
}
