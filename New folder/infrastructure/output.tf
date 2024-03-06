output "vpc_id" {
  value = module.dev_network.vpc_id
}

output "pub_subnet_id" {
  value = module.dev_network.pub_subnet_id
}

output "pri_subnet_id" {
  value = module.dev_network.pri_subnet_id
}

output "igw_id" {
  value = module.dev_network.igw_id
}

output "public_routeTable_id" {
  value = module.dev_network.public_routeTable_id
}

output "natgw_id" {
  value = module.dev_network.natgw_id
}

output "eip_id" {
  value = module.dev_network.eip_id
}
