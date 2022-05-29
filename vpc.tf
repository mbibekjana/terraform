resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform"
  }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public2"
  }
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.11.0/24"

  tags = {
    Name = "private1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.12.0/24"

  tags = {
    Name = "private2"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
resource "aws_eip" "eip" {
  vpc      = true
}
resource "aws_nat_gateway" "natg" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id

}
resource "aws_route_table" "IG_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
}
resource "aws_route_table" "NAT_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natg.id
  }

}

resource "aws_route_table_association" "public_subnet1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.IG_route_table.id
}
resource "aws_route_table_association" "public_subnet2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.IG_route_table.id
}
resource "aws_route_table_association" "private_subnet1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.NAT_route_table.id
}
resource "aws_route_table_association" "private_subnet2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.NAT_route_table.id
}