resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, { Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-vpc" })
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet1_cidr_block
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = var.enable_public_ip
  tags                    = merge(var.tags, { Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-public-subnet-1" })

}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet2_cidr_block
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = var.enable_public_ip
  tags                    = merge(var.tags, { Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-public-subnet-2" })
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet1_cidr_block
  availability_zone = var.availability_zones[0]
  tags              = merge(var.tags, { Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-private-subnet-1" })

}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet2_cidr_block
  availability_zone = var.availability_zones[1]
  tags              = merge(var.tags, { Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-private-subnet-2" })

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, { 
    Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-igw"
     })
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { 
    Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-public-rtb"
     })
}

resource "aws_route_table_association" "pub_sub1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "pub_sub2_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  tags = merge(var.tags, { 
    Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-nat-gw"
     })
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = merge(var.tags, { 
    Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-nat-gw"
     })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.nat_eip, aws_subnet.public_subnet1]
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge(var.tags, { 
    Name = "${var.tags["Project"]}-${var.tags["Application"]}-${var.tags["Environment"]}-private-rtb"
     })
}

resource "aws_route_table_association" "priv_sub1_association" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "priv_sub2_association" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rtb.id
}