# create instance for mongodb
resource "aws_instance" "mongodb" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id              = local.database_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-mongodb"
    }
  )
}

# null-resource used for run the script useing terraform life cycle, it create any resource
resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
  
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
    ]
  }
}

# # create instance for redis
# resource "aws_instance" "redis" {
#   ami                    = local.ami_id
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [local.redis_sg_id]
#   subnet_id              = local.database_subnet_ids

#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${var.project_name}-${var.environment}-redis"
#     }
#   )
# }

# resource "terraform_data" "redis" {
#   triggers_replace = [
#     aws_instance.redis.id
#   ]

#   provisioner "file" {
#     source      = "bootstrap.sh"
#     destination = "/tmp/bootstrap.sh"
#   }

#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = "DevOps321"
#     host     = aws_instance.redis.private_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/bootstrap.sh",
#       "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
#     ]
#   }
# }

# create resource for mysql
resource "aws_instance" "mysql" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_ids

  # to fetch data from ssm parameter we use aws roles #### on session 42 - T16
  # it fetches the stored password from ssmparameter
  iam_instance_profile = "EC2RoleToFetchSSM"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-mysql"
    }
  )
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}

# # create resource for rabbitmq
# resource "aws_instance" "rabbitmq" {
#   ami                    = local.ami_id
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [local.redis_sg_id]
#   subnet_id              = local.database_subnet_ids

#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${var.project_name}-${var.environment}-rabbitmq"
#     }
#   )
# }

# resource "terraform_data" "rabbitmq" {
#   triggers_replace = [
#     aws_instance.rabbitmq.id
#   ]

#   provisioner "file" {
#     source      = "bootstrap.sh"
#     destination = "/tmp/bootstrap.sh"
#   }

#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = "DevOps321"
#     host     = aws_instance.rabbitmq.private_ip
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/bootstrap.sh",
#       "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
#     ]
#   }
# }

resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.zone_name}" #mongodb-dev.akdevops.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true #used to overwrite the old records
}

resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.zone_name}" #mongodb-dev.akdevops.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true #used to overwrite the old records
}

