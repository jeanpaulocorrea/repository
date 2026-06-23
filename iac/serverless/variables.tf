variable "region" {
  type    = string
  default = "us-east-1"

}
variable "assume_role" {
  type = object({
    role_arn    = string
    external_id = string
  })

  default = {
    role_arn    = "arn:aws:iam::080744442776:role/terraform-role"
    external_id = "a690f6f2-7ca0-4851-ba7a-c2282887c529"
  }


}

variable "tags" {
  type = object({
    Environment = string
    Project     = string
  })
  default = {
    Environment = "Production"
    Project     = "NSSE"
  }

}

variable "queues" {
  type = list(object({
    name                      = string
    delay_seconds             = number
    max_message_size          = number
    message_retention_seconds = number
    receive_wait_time_seconds = number
    sqs_managed_sse_enabled   = bool
  }))
  default = [
    {
      name                      = "EmailNotificationsQueue"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true

    },
    {
      name                      = "ProductStockQueue"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true

    },
    {
      name                      = "InvoiceQueue"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true

    }
  ]
}

variable "dlqueues" {
  type = list(object({
    name                      = string
    delay_seconds             = number
    max_message_size          = number
    message_retention_seconds = number
    receive_wait_time_seconds = number
    sqs_managed_sse_enabled   = bool
  }))
  default = [
    {
      name                      = "EmailNotificationsQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true

    },
    {
      name                      = "ProductStockQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true

    },
    {
      name                      = "InvoiceQueueDlq"
      delay_seconds             = 0
      max_message_size          = 2048
      message_retention_seconds = 86400
      receive_wait_time_seconds = 10
      sqs_managed_sse_enabled   = true

    }
  ]

}

variable "order_confirmed_topic" {
  type = object({
    role_name                        = string
    name                             = string
    sqs_success_feedback_sample_rate = number
    subscriptions                    = list(string)
  })
  default = {


    role_name                        = "SnsTopicRole"
    name                             = "OrderConfirmedTopic"
    sqs_success_feedback_sample_rate = 100
    subscriptions                    = ["InvoiceQueue", "ProductStockQueue"]
  }

}

variable "s3_application_bucket_name" {
  type    = string
  default = "jean-nsse-application-bucket"
}


variable "vpc_resources" {
  type = object({
    vpc = string
  })

  default = {
    vpc = "nsse-production-vpc"
  }

}

variable "security_groups" {
  type = object({
    control_plane = string
    worker        = string
    rds           = string


  })

  default = {
    control_plane = "nsse-production-control-plane-security-group"
    worker        = "nsse-production-worker-security-group"
    rds           = "nsse-production-rds-security-group"
  }

}

variable "rds_aurora_cluster" {
  type = object({
    cluster_identifier = string
    engine             = string
    engine_mode        = string
    database_name      = string
    master_username    = string
    availability_zones = list(string)
    #final_snapshot_identifier    = string
    skip_final_snapshot          = bool
    db_subnet_group_name         = string
    deletion_protection          = bool
    storage_encrypted            = bool
    manage_master_user_password  = bool
    preferred_maintenance_window = string,
    instances = list(object({
      identifier        = string
      instance_class    = string
      availability_zone = string
    }))
    serverless_scaling_configuration = object({
      max_capacity = number
      min_capacity = number
    })
  })

  default = {
    cluster_identifier = "nsse-aurora-serverless-cluster"
    engine             = "aurora-postgresql"
    engine_mode        = "provisioned"
    database_name      = "NotSoSimpleEcommerce"
    master_username    = "nsseAdmin"
    availability_zones = ["us-east-1a", "us-east-1b"]
    #final_snapshot_identifier    = "nsse-aurora-serverless-cluster-final-snapshot"
    skip_final_snapshot          = true
    db_subnet_group_name         = "nsse-production-db-subnet-group"
    deletion_protection          = false #deixar em true para ambientes de produção
    storage_encrypted            = true
    manage_master_user_password  = true
    preferred_maintenance_window = "sun:05:00-sun:06:00",
    instances = [
      {
        identifier        = "nsse-instance-us-east-1a"
        instance_class    = "db.serverless"
        availability_zone = "us-east-1a"
      },
      {
        identifier        = "nsse-instance-us-east-1b"
        instance_class    = "db.serverless"
        availability_zone = "us-east-1b"
      }
    ]
    serverless_scaling_configuration = {
      max_capacity = 1.0
      min_capacity = 0.0
    }

  }
}

variable "db_subnet_group" {
  type    = string
  default = "nsse-production-db-subnet-group"
}
variable "rds_proxy" {
  type = object({
    name                = string
    read_only_endpoint  = string
    debug_logging       = bool
    engine_family       = string
    idle_client_timeout = number
    require_tls         = bool
    role_name           = string
    policy_name         = string
    auth = object({
      auth_scheme = string
      iam_auth    = string
    })
  })

  default = {
    name                = "nsse-aurora-serverless-cluster-proxy"
    read_only_endpoint  = "nsse-aurora-serverless-cluster-readonly"
    debug_logging       = false
    engine_family       = "POSTGRESQL"
    idle_client_timeout = 300
    require_tls         = true
    role_name           = "nsse-production-rds-proxy-role"
    policy_name         = "nsse-production-rds-proxy-policy"
    auth = {
      auth_scheme = "SECRETS"
      iam_auth    = "DISABLED"
    }
  }

}

variable "document_db_cluster" {
  type = object({
    cluster_identifier           = string
    engine                       = string
    engine_version               = string
    master_username              = string
    backup_retention_period      = number
    preferred_backup_window      = string
    preferred_maintenance_window = string
    #final_snapshot_identifier       = string
    skip_final_snapshot             = bool
    storage_encrypted               = bool
    vpc_security_group_ids          = list(string)
    availability_zones              = list(string)
    enabled_cloudwatch_logs_exports = list(string)
    subnet_group_name               = string
    db_cluster_parameter_group_name = string
    security_group_name             = string
    security_group_description      = string
    secret_name                     = string
    secret_recovery_window_in_days  = number
    instance_class                  = string
    instance_identifier             = string
    parameter_group = object({
      family = string
      parameters = list(object({
        name  = string
        value = string
      }))
    })

  })

  default = {
    cluster_identifier           = "nssse-documentdb-cluster"
    engine                       = "docdb"
    engine_version               = "5.0.0"
    master_username              = "nsse"
    backup_retention_period      = 7
    preferred_backup_window      = "01:00-02:00"
    preferred_maintenance_window = "sun:03:00-sun:04:00"
    #final_snapshot_identifier       = "nssse-documentdb-cluster-final-snapshot"
    skip_final_snapshot             = true
    storage_encrypted               = true
    vpc_security_group_ids          = ["nsse-documentdb-cluster-secutity-group"]
    availability_zones              = ["us-east-1a", "us-east-1b"]
    enabled_cloudwatch_logs_exports = ["profiler", "audit"]
    subnet_group_name               = "nsse-production--docdb-subnet-group"
    db_cluster_parameter_group_name = "nsse-documentdb-parameter-group"
    security_group_name             = "nsse-documentdb-cluster-secutity-group"
    security_group_description      = "Managing ports for DocumentDB"
    secret_name                     = "nsse-documentdb-secret-v2"
    secret_recovery_window_in_days  = 0
    instance_class                  = "db.t3.medium"
    instance_identifier             = "nsse-documentdb-cluster-single-instance"
    parameter_group = {
      family = "docdb5.0"
      parameters = [
        {
          name  = "audit_logs"
          value = "enabled"
        },
        {
          name  = "profiler"
          value = "enabled"
        }
      ]
    }


  }

}

variable "lambda_order_confirmed" {
  type = object({
    package_type  = string
    source_dir    = string
    output_path   = string
    filename      = string
    function_name = string
    handler       = string
    runtime       = string
    role_name     = string
    policy_name   = string
  })

  default = {
    package_type  = "zip"
    source_dir    = "lambdas/order-confirmed/build"
    output_path   = "lambdas/order-confirmed/outputs/package.zip"
    filename      = "lambdas/order-confirmed/outputs/package.zip"
    function_name = "OrderConfirmedLambdaFunction"
    handler       = "index.handler"
    runtime       = "nodejs24.x"
    role_name     = "nsse-production-order-confirmed-lambda-role"
    policy_name   = "nsse-production-order-confirmed-lambda-policy"
  }
}
