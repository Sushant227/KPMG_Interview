variable "public_subnet_numbers" {
  type = map(string)
 
  description = "public subnets and respective CIDR"
 
  default = {
    "us-east-2a" = "10.0.1.0/24"
    "us-east-2b" = "10.0.2.0/24"
    "us-east-2c" = "10.0.3.0/24"
  }
}
 
variable "private_subnet_numbers" {
  type = map(string)
 
  description = "private subnets and respective CIDR"
 
  default = {
    "us-east-2a" = "10.0.5.0/24"
    "us-east-2b" = "10.0.6.0/24"
    "us-east-2c" = "10.0.7.0/24"
  }
}

variable "database_subnet_numbers" {
  type = map(string)
 
  description = "database subnets and respective CIDR"
 
  default = {
    "us-east-2a" = "10.0.10.0/24"
    "us-east-2b" = "10.0.11.0/24"
    "us-east-2c" = "10.0.12.0/24"
  }
}
variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}
 
variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default = "Interview"
}

variable "asg_id" {
  type = string
}