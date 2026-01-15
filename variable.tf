variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

# RDS Variables
variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

# Elastic Beanstalk Variables
variable "eb_instance_type" {
  description = "Instance type for Elastic Beanstalk"
  type        = string
  default     = "t3.micro"
}

variable "eb_min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "eb_max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}

variable "default-route" {
  description = "default"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}