#COMMON
variable "project_name" {
    default = "Maestria Grupo 2"
}
variable "access_key" {
    default="XXXXXXXXXXXXXXXXXX"
 }
variable "secret_key" {
    default="XXXXXXXXXXXXXXXXXXXXXXx"
 }


variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "principal_availability_zone" {
  description = "av zone"
  default="us-east-1a"
}
variable "secondary_availability_zone" {
  description = "av zone"
  default="us-east-1b"
}
variable "environment" {
  description = "environment name"
  default="PRODUCTION"
}

#VPC

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.9.0.0/16"
}

variable "public_subnet" {
    description = "public CIDR"
    default = "10.9.1.0/24"
}

variable "backend_subnet" {
    description = "backend CIDR"
    default = "10.9.2.0/24"
}

variable "private_subnet_db_cidr" {
    description = "backend CIDR"
    default = "10.9.3.0/24"
}
variable "private_subnet_db_secondary_cidr" {
    description = "backend CIDR"
    default = "10.9.203.0/24"
}

variable "private_subnet_bastion" {
    description = "backend CIDR"
    default = "10.9.100.0/24"
}
#AMI

variable "default_ami_ubuntu" {
  default = {
    us-east-1 = "ami-024a64a6685d05041"
  }
}



variable "password_rds" {
  description = "rds pass"
default="LLENAME"
}

variable "username_rds" {
  description = "rds username"
  default="grupo2"
}
