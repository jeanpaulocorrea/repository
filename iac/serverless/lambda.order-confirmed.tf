data "archive_file" "lambda" {
  type        = var.lambda_order_confirmed.package_type
  source_dir  = var.lambda_order_confirmed.source_dir
  output_path = var.lambda_order_confirmed.output_path
}

resource "aws_lambda_function" "order_confirmed" {
  filename      = var.lambda_order_confirmed.filename
  function_name = var.lambda_order_confirmed.function_name
  role          = aws_iam_role.order_confirmed_lambda_role.arn
  handler       = var.lambda_order_confirmed.handler
  code_sha256   = data.archive_file.lambda.output_base64sha256

  runtime = var.lambda_order_confirmed.runtime

  vpc_config {
    subnet_ids         = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.postgressql.id]
  }

  environment {
    variables = {
      RDS_PROXY_ENDPOINT = aws_db_proxy.this.endpoint
      RDS_SECRET_ARN     = aws_rds_cluster.this.master_user_secret[0].secret_arn
      SNS_TOPIC_ARN      = aws_sns_topic.order_confirmed_topic.arn
      RDS_DATABASE_NAME  = aws_rds_cluster.this.database_name
    }
  }

  tags = var.tags

}
