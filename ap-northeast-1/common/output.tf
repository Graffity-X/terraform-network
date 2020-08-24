
output "vpc" {
  value = aws_vpc.vpc
}

output "internet_gateway" {
  value = aws_internet_gateway.gw
}
