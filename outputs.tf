output "container_definitions" {
  description = "A list of container definitions in JSON format that describe the different containers that make up your task"
  value       = "${local.container_definitions}"
}
