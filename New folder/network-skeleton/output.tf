output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "pub_subnet_id" {
 value = aws_subnet.my_public_subnet.*.id
}

output "pri_subnet_id" {
value = aws_subnet.my_private_subnet.*.id
}

output "igw_id" {
value = aws_internet_gateway.my_igw.id
}

output "public_routeTable_id" {
  value = aws_route_table.public_routeTable.id
}

output "private_routeTable_id" {
  value = aws_route_table.private_routeTable.id
}
