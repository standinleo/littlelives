resource "aws_iam_role" "eb_service" {
  name = "${var.app_name}-eb-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role" "eb_ec2" {
  name = "${var.app_name}-eb-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "eb_ec2_web" {
  role       = aws_iam_role.eb_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy" "parameter_store" {
  name = "${var.app_name}-parameter-store-policy"
  role = aws_iam_role.eb_ec2.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/contactform/*",
          "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:rds!db-*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "eb_ec2" {
  name = "${var.app_name}-eb-ec2-profile"
  role = aws_iam_role.eb_ec2.name
}

# S3 access policies
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.eb_ec2.name
  policy_arn = var.s3_access_policy_arn
}

resource "aws_iam_role_policy_attachment" "s3_deployment_access" {
  role       = aws_iam_role.eb_ec2.name
  policy_arn = var.s3_deployment_policy_arn
}