#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/akthinq1/anisible-roboshop-roles-tf.git -e component=$1 -e env=$2 main.yaml

# https://github.com/akthinq1/anisible-roboshop-roles.git

# https://github.com/daws-84s/ansible-roboshop-roles-tf.git