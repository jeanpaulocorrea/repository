data "aws_route53_zone" "this" {
  name         = "devopsnanuvem.com"
  private_zone = true
}
