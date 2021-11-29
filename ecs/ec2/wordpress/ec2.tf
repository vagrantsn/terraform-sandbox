data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-0fe19057e9cb4efd8"]
  }

  owners = ["amazon"]
}

resource "aws_iam_role" "ecs" {
  name = "ecsPermissionsForEc2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs" {
  name       = "ecsPermissionsForEc2Attachment"
  roles      = [aws_iam_role.ecs.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  role = aws_iam_role.ecs.name
}

resource "aws_security_group" "ec2SecurityGroup" {
  name   = "wordpress-ec2-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "all"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "all"
  }
}

resource "aws_instance" "ec2" {
  count                       = length(aws_subnet.public)
  ami                         = data.aws_ami.ecs.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  iam_instance_profile        = aws_iam_instance_profile.ecs.id
  security_groups             = [aws_security_group.ec2SecurityGroup.id]

  user_data = <<EOF
  #!/bin/bash
  echo ECS_CLUSTER=wordpress >> /etc/ecs/ecs.config
  EOF

  tags = {
    "Name" = "Wordpress EC2"
  }
}
