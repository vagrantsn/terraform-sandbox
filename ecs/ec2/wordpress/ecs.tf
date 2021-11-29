locals {
  task_definition = templatefile("task-definition.tpl", {
    db_host     = aws_db_instance.mysql.endpoint
    db_user     = "wordpress"
    db_password = "wordpress"
    db_name     = "wordpress"
  })
}

resource "aws_ecs_cluster" "cluster" {
  name = "wordpress"
}

resource "aws_ecs_service" "service" {
  name = "wordpress"

  cluster       = aws_ecs_cluster.cluster.id
  desired_count = 2
  launch_type   = "EC2"

  network_configuration {
    subnets = aws_subnet.public.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target.arn
    container_name   = "wordpress"
    container_port   = 80
  }

  task_definition = aws_ecs_task_definition.wp.arn
}

resource "aws_ecs_task_definition" "wp" {
  family                = "wordpress"
  network_mode          = "awsvpc"
  cpu                   = 256
  memory                = 512
  container_definitions = local.task_definition
  execution_role_arn    = aws_iam_role.exec.arn
}
