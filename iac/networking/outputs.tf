output "vpc_id" {
  value = aws_vpc.this

}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id

}

output "nat_gateway_id_gateway_id" {
  value = aws_nat_gateway.this[*].id

}

output "puplic_sunets_ids" {
  value = aws_subnet.public[*].id

}

output "private_sunets_ids" {
  value = aws_subnet.private[*].id

}
