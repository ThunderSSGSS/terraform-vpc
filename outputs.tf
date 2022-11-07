output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "internet_gateway_id" {
    value = aws_internet_gateway.vpc_internet_gateway.id
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.private_subnets[*].id
}