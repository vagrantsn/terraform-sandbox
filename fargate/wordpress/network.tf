resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Wordpress"
  }
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
