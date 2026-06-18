resource "aws_security_group" "documentdb" {
  name        = var.document_db_cluster.security_group_name
  description = var.document_db_cluster.security_group_description
  vpc_id      = data.aws_vpc.this.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [data.aws_security_group.worker.id, data.aws_security_group.control_plane.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = var.document_db_cluster.security_group_name
  })
}


