aws_region   = "us-east-1" # Updated to match your subnet region
project_name = "dev-php-app"
environment  = "dev-account"

# RDS Configuration
db_name     = "appdb"
db_username = "dbadmin"

# VPC Configuration
default-route = "0.0.0.0/0"
vpc_cidr      = "10.0.0.0/16"

# Elastic Beanstalk Configuration
eb_instance_type = "t3.micro"
eb_min_instances = 2
eb_max_instances = 4