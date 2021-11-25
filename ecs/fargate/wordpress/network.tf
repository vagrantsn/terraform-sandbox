locals {
  zones         = ["us-east-1a", "us-east-1b"]
  public_cidrs  = ["10.0.0.0/24"]
  private_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Wordpress"
  }
}

### Route tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_internet.id
}

### Gateways

resource "aws_internet_gateway" "public_internet" {
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

### Public Subnets

resource "aws_subnet" "public" {
  count                   = length(local.public_cidrs)
  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(local.zones, count.index)
  cidr_block              = element(local.public_cidrs, count.index)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Wordpress Public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public.*)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

### Private Subnets

resource "aws_subnet" "private" {
  count                   = length(local.private_cidrs)
  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(local.zones, count.index)
  cidr_block              = element(local.private_cidrs, count.index)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Wordpress Private ${count.index}"
  }
}
