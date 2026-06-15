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
    cluster_identifier           = string
    engine                       = string
    engine_mode                  = string
    database_name                = string
    master_username              = string
    availability_zones           = list(string)
    final_snapshot_identifier    = string
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
    cluster_identifier           = "nsse-aurora-serverless-cluster"
    engine                       = "aurora-postgresql"
    engine_mode                  = "provisioned"
    database_name                = "NotSoSimpleEcommerce"
    master_username              = "nsseAdmin"
    availability_zones           = ["us-east-1a", "us-east-1b"]
    final_snapshot_identifier    = "nsse-aurora-serverless-cluster-final-snapshot"
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
