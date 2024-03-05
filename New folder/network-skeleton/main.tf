resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "my_public_subnet" {
  count  = length(var.pub_subnet_cidr)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block        = element(var.pub_subnet_cidr , count.index)
  availability_zone = element(var.subnet_az ,count.index)
  tags = {
    Name = element(var.pub_subnet_name ,count.index)
  }
}

resource "aws_subnet" "my_private_subnet" {
  count  = length(var.pri_subnet_cidr)
  cidr_block = var.pri_subnet_cidr[count.index]
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone = element(var.subnet_az ,count.index)
  tags = {
    Name = element(var.pri_subnet_name ,count.index)
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public_routeTable" {
  vpc_id =  aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
Name = var.public_rt_name
}
}
