resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Wordpress"
  }
}

resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "Wordpress"
  }
}

resource "aws_security_group_rule" "http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_vpc.main.default_security_group_id
}

resource "aws_subnet" "main_a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"

  tags = {
    "Name" = "Wordpress A"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_a.id
  route_table_id = aws_vpc.main.default_route_table_id
}
