variable "region" {
   description = "name of the region"
   type = string
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "vpc_name" {
  description = "Name tag of the VPC"
  type        = string
}

variable "pub_subnet_cidr" {
  description = "CIDR of public subnet"
  type        = list(string)
}

variable "subnet_az" {
  description = "AZ for public subnet"
  type        = list(string)
}

variable "pub_subnet_name" {
  description = "Name tag of the pub subnet name"
  type        = list(string)
}

variable "pri_subnet_cidr" {
  description = "CIDR of private subnet"
  type        = list(string)
}

variable "pri_subnet_name" {
  description = "Name tag of the pri subnet name"
  type        = list(string)
}

variable "igw_name" {
  description = "Name tag of the igw_name"
  type        = string
}

variable "public_rt_name" {
  description = "Name tag of the public rt name"
  type        = string
}

variable "enable_vpc_logs" {
  description = "whether vpc flow log enable or not"
  type        = bool
}

variable "vpc_flow_log_s3_name" {
  description = "vpc s3 name"
  type        = string
}

variable "vpc-flow-logs-role" {
    description = "vpc iam role"
     type        = string
}
