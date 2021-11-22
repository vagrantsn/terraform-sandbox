resource "aws_security_group" "mysql" {
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3306
    protocol    = "tcp"
    to_port     = 3306
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "wp" {
  subnet_ids = [aws_subnet.main_a.id, aws_subnet.main_b.id]
}

resource "aws_db_instance" "mysql" {
  allocated_storage = 5
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  multi_az          = false

  name     = "wordpress"
  username = "wordpress"
  password = "wordpress"

  db_subnet_group_name = aws_db_subnet_group.wp.name

  vpc_security_group_ids = [aws_security_group.mysql.id]

  skip_final_snapshot = true
}
