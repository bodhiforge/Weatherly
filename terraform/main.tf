provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "weather_cluster" {
  name = "weather-cluster"
}

resource "aws_security_group" "ecs_security_group" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ecs-security-group"
  }
}

resource "aws_ecs_service" "frontend_service" {
  name           = "frontend-service"
  cluster        = aws_ecs_cluster.weather_cluster.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public_subnet[*].id
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }

  tags = {
    Name = "frontend-service"
  }
}

resource "aws_ecs_service" "backend_service" {
  name           = "backend-service"
  cluster        = aws_ecs_cluster.weather_cluster.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public_subnet[*].id
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }

  tags = {
    Name = "backend-service"
  }
}

resource "aws_security_group_rule" "allow_http_frontend" {
  type        = "ingress"
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_security_group.id
}

resource "aws_security_group_rule" "allow_http_backend" {
  type        = "ingress"
  from_port   = 4000
  to_port     = 4000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_security_group.id
}

resource "aws_security_group_rule" "allow_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_security_group.id
}

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::050752643187:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([{
    name      = "frontend-container",
    image     = "050752643187.dkr.ecr.us-west-2.amazonaws.com/weather-frontend:latest",
    portMappings = [{
      containerPort = 3000
    }]
  }])
}

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::050752643187:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([{
    name      = "backend-container",
    image     = "050752643187.dkr.ecr.us-west-2.amazonaws.com/weather-backend:latest",
    portMappings = [{
      containerPort = 4000
    }]
  }])
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "weather-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "weather-public-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {}