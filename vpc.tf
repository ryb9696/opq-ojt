provider "aws" {
  region = "us-east-1"

}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc"
  }

}
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "vpc_igw"
  }

}
resource "aws_subnet" "vpc_pub" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "vpc_pub"
  }

}
resource "aws_subnet" "vpc_pvt" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "vpc_pub"
  }
}
resource "aws_eip" "vpc_eip" {
  tags = {
    Name = "vpc_eip"
  }

}
resource "aws_nat_gateway" "vpc_nat" {
  allocation_id = aws_eip.vpc_eip.id
  subnet_id     = aws_subnet.vpc_pub.id
  tags = {
    Name = "vpc_nat"
  }
}
resource "aws_route_table" "vpc_rt_pub" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

}
resource "aws_route_table" "vpc_rt_pvt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_nat_gateway.vpc_nat.id
  }
}
resource "aws_route_table_association" "vpc_ass_pub" {
  subnet_id      = aws_subnet.vpc_pub.id
  route_table_id = aws_route_table.vpc_rt_pub.id

}
resource "aws_route_table_association" "vpc_ass_pvt" {
  subnet_id      = aws_subnet.vpc_pvt.id
  route_table_id = aws_route_table.vpc_rt_pvt.id

}
resource "aws_security_group" "vpc_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "alb_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.vpc_sg.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.vpc_sg.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.vpc_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
