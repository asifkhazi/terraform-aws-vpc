resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
    instance_tenancy = "default"
}
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "tcsbdc-igw"
    }
}
resource "aws_subnet" "my_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.availability_zone1
  tags = {
    Name = "tcsbdc-sub1-pub"
  }
}
resource "aws_subnet" "my_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.availability_zone2
  tags = {
    Name = "tcsbdc-sub2-pri"
  }
}
resource "aws_route_table" "my_route_table1" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tcsbdc-rt1-pub"
  }
  route {
    gateway_id = aws_internet_gateway.my_igw.id
    cidr_block = "0.0.0.0/0"
  }
}
resource "aws_route_table" "my_route_table2" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tcsbdc-rt2-pri"
  }
}
resource "aws_route_table_association" "my_rt_association1" {
  subnet_id      = aws_subnet.my_subnet1.id
  route_table_id = aws_route_table.my_route_table1.id
}
resource "aws_route_table_association" "my_rt_association2" {
  subnet_id      = aws_subnet.my_subnet2.id
  route_table_id = aws_route_table.my_route_table2.id
}
resource "aws_security_group" "my_sg1" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tcsbdc-sg1-pub"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "my_sg2" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tcsbdc-sg2-pri"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

