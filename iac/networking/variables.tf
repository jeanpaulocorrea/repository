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
  type = map(string)
  default = {
    "Environment" = "not-so-simple-ecommerce",
    "Project"     = "production"
  }
}

variable "vpc" {
  type = object({
    name                      = string
    cidr_block                = string
    aws_internet_gateway_name = string
    aws_nat_gateway_name      = string
    public_route_table_name   = string
    private_route_table_name  = string
    eip_name                  = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool

    }))
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool

    }))
  })

  default = {
    name                      = "nsse-production-vpc"
    cidr_block                = "10.0.0.0/24"
    aws_internet_gateway_name = "internet-gateway"
    aws_nat_gateway_name      = "nat-gateway"
    public_route_table_name   = "public-route-table"
    private_route_table_name  = "private-route-table"
    eip_name                  = "nat-gateway-eip"
    public_subnets = [{
      name                    = "public-subnet-us-east-1a"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.0.0.0/27"
      map_public_ip_on_launch = true

      },
      {
        name                    = "public-subnet-us-east-1b"
        availability_zone       = "us-east-1b"
        cidr_block              = "10.0.0.64/27"
        map_public_ip_on_launch = true
    }]
    private_subnets = [{
      name                    = "private-subnet-us-east-1a"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.0.0.32/27"
      map_public_ip_on_launch = false

      },
      {
        name                    = "private-subnet-us-east-1b"
        availability_zone       = "us-east-1b"
        cidr_block              = "10.0.0.96/27"
        map_public_ip_on_launch = false
    }]
  }
}
