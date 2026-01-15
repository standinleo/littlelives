resource "aws_db_instance" "main" {
  identifier        = var.identifier
  allocated_storage = var.allocated_storage
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  db_name           = var.db_name
  username          = var.db_username

  manage_master_user_password = true
  skip_final_snapshot         = true

  vpc_security_group_ids = [var.rds_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = var.tags
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

# Store database parameters in Parameter Store
resource "aws_ssm_parameter" "db_host" {
  name  = "/contactform/db-host"
  type  = "String"
  value = aws_db_instance.main.endpoint

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/contactform/db-name"
  type  = "String"
  value = var.db_name

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/contactform/db-username"
  type  = "String"
  value = var.db_username

  lifecycle {
    ignore_changes = [value]
  }

}