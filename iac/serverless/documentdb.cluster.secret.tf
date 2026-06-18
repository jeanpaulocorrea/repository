resource "aws_secretsmanager_secret" "documentdb_cluster" {
  name                    = var.document_db_cluster.secret_name
  recovery_window_in_days = var.document_db_cluster.secret_recovery_window_in_days
  tags                    = var.tags
}

data "aws_secretsmanager_random_password" "documentdb_cluster" {
  password_length     = 30
  exclude_punctuation = true
}

resource "aws_secretsmanager_secret_version" "first" {
  secret_id = aws_secretsmanager_secret.documentdb_cluster.id
  secret_string = jsonencode({
    username = var.document_db_cluster.master_username
    password = data.aws_secretsmanager_random_password.documentdb_cluster.random_password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}



