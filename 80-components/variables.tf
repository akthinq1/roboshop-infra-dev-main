variable "components" {
  default = {
    # rule priority should not be same on same load balancer. we can use same rule priority on multiple LB
    catalogue={
        rule_priority=10
    }
    user={
        rule_priority=20
    }
    cart={
        rule_priority=30
    }       
    shipping={
        rule_priority=40
    }
    payment={
        rule_priority=50
    }
    frontend={
        rule_priority=10
    }
  }
}