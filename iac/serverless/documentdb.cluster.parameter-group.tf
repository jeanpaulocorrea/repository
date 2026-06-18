resource "aws_docdb_cluster_parameter_group" "this" {
  family = "docdb5.0"
  name   = "nsse-documentdb-parameter-group"

  parameter {
    name  = "audit_logs"
    value = "enabled"
  }
  parameter {
    name  = "profiler"
    value = "enabled"
  }

}
