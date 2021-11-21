resource "aws_ecs_cluster" "cluster" {
  name = "wordpress"
}

resource "aws_ecs_service" "service" {
  name = "wordpress"

  cluster       = aws_ecs_cluster.cluster.id
  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.main_a.id]
    assign_public_ip = true
  }

  task_definition = aws_ecs_task_definition.wp.arn
}

resource "aws_ecs_task_definition" "wp" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = file("task-definition.json")
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.exec.arn
}
