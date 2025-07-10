module "component" {
  for_each      = var.components
  source        = "git::https://github.com/akthinq1/terraform-aws-roboshop.git?ref=main"
  project_name  = "roboshop"
  environment   = "dev"
  component     = each.key
  rule_priority = each.value.rule_priority
}
