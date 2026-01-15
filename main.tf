# Get AWS account ID
data "aws_caller_identity" "current" {}

module "s3" {
  source = "./modules/s3"

  bucket_name            = "${var.project_name}-uploads-${var.environment}"
  deployment_bucket_name = "${var.project_name}-deployment-${var.environment}"
  tags                   = local.tags
}

module "network" {
  source = "./modules/network"

  project_name  = var.project_name
  environment   = var.environment
  vpc_cidr      = var.vpc_cidr
  default-route = var.default-route
}

module "rds" {
  source = "./modules/rds"

  identifier            = "${var.project_name}-db-${var.environment}"
  allocated_storage     = var.db_allocated_storage
  instance_class        = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.private_subnet_ids
  rds_security_group_id = module.security.rds_security_group_id
  tags                  = local.tags
}

module "iam" {
  source = "./modules/iam"

  aws_account_id           = data.aws_caller_identity.current.account_id
  tags                     = local.tags
  aws_region               = var.aws_region
  app_name                 = var.project_name
  s3_access_policy_arn     = module.s3.access_policy_arn
  s3_deployment_policy_arn = module.s3.deployment_access_policy_arn

}

module "elastic_beanstalk" {
  source = "./modules/elastic-beanstalk"

  app_name                   = var.project_name
  app_description            = "PHP application with RDS and S3"
  environment_name           = "${var.project_name}-${var.environment}"
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_ids
  instance_type              = var.eb_instance_type
  min_instances              = var.eb_min_instances
  max_instances              = var.eb_max_instances
  alb_security_group_id      = module.security.alb_security_group_id
  instance_profile_name      = module.iam.eb_ec2_instance_profile_name
  instance_security_group_id = module.security.instance_security_group_id
  public_subnet_ids          = module.network.public_subnet_ids
  private_subnet_ids         = module.network.private_subnet_ids
  aws_region                 = var.aws_region
  aws_account_id             = data.aws_caller_identity.current.account_id
  tags                       = local.tags
  service_role_arn           = module.iam.eb_service_role_arn
  uploads_bucket_name        = module.s3.bucket_name
  db_secret_arn              = module.rds.secret_arn
}

module "security" {
  source = "./modules/security"

  vpc_id        = module.network.vpc_id
  tags          = local.tags
  environment   = var.environment
  project_name  = var.project_name
  default-route = var.default-route
}

locals {
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}