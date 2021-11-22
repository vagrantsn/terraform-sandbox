[
  {
    "name": "wordpress",
    "image": "wordpress",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "environment": [
      { "name": "WORDPRESS_DB_HOST", "value": "${db_host}" },
      { "name": "WORDPRESS_DB_USER", "value": "${db_user}" },
      { "name": "WORDPRESS_DB_PASSWORD", "value": "${db_password}" },
      { "name": "WORDPRESS_DB_NAME", "value": "${db_name}" }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "wordpress-web",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "wordpress",
        "awslogs-create-group": "true"
      }
    }
  }
]
