resource "aws_security_group" "mysql" {
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 3306
    protocol    = "tcp"
    to_port     = 3306
  }

  egress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    protocol    = "tcp"
    to_port     = 0
  }
}

resource "aws_db_subnet_group" "private" {
  subnet_ids = flatten([aws_subnet.private.*.id])
}

resource "aws_db_instance" "mysql" {
  allocated_storage = 5
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  storage_type      = "gp2"
  multi_az          = false

  name     = "wordpress"
  username = "wordpress"
  password = "wordpress"

  db_subnet_group_name   = aws_db_subnet_group.private.name
  vpc_security_group_ids = [aws_security_group.mysql.id]

  skip_final_snapshot = true
}
