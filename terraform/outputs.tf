output "frontend_service_url" {
  value = aws_ecs_service.frontend_service.id
}

output "backend_service_url" {
  value = aws_ecs_service.backend_service.id
}
