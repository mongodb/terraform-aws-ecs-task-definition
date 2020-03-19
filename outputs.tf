output "arn" {
  description = "The full Amazon Resource Name (ARN) of the task definition"
  value       = join("", aws_ecs_task_definition.ecs_task_definition.*.arn)
}

output "container_definitions" {
  description = "A list of container definitions in JSON format that describe the different containers that make up your task"
  value       = local.container_definitions
}

output "family" {
  description = "The family of your task definition, used as the definition name"
  value       = join("", aws_ecs_task_definition.ecs_task_definition.*.family)
}

output "revision" {
  description = "The revision of the task in a particular family"
  value       = join("", aws_ecs_task_definition.ecs_task_definition.*.revision)
}

