# The ternary operators in this module are mandatory. All composite types (e.g., lists and maps) require encoding to
# pass as arguments to the Terraform `template_file`[1] data source The `locals.tf` file contains the encoded values of
# the composite types defined in the ECS Task Definition[2]. Certain variables, such as `healthCheck`, `linuxParameters`
# and `portMappings`, require the `replace` function since they contain numerical values. For example, given the
# following JSON:
#
#     -var 'portMappings=[{containerPort = 80, protocol = "TCP"}]'
#
#     [
#       {
#         "containerDefinitions": [
#           {
#             "portMappings": [
#               {
#                 "containerPort": 80,
#                 "protocol": "TCP"
#               }
#             ]
#           }
#         ]
#       }
#     ]
#
# Since the `containerPort` and `hostPort`[3] fields are both integer types, then the `replace` function is necessary to
# prevent quoting the value in strings. This issue is a known limitation in the Terraform `jsonencode`[4] function.
#
#  - 1. https://www.terraform.io/docs/providers/template/d/file.html
#  - 2. https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html
#  - 3. https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PortMapping.html
#  - 4. https://github.com/hashicorp/terraform/issues/17033

locals {
  command               = jsonencode(var.command)
  dnsSearchDomains      = jsonencode(var.dnsSearchDomains)
  dnsServers            = jsonencode(var.dnsServers)
  dockerLabels          = jsonencode(var.dockerLabels)
  dockerSecurityOptions = jsonencode(var.dockerSecurityOptions)
  entryPoint            = jsonencode(var.entryPoint)
  extraHosts            = jsonencode(var.extraHosts)

  environment = jsonencode(var.environment != {} ? [for k, v in var.environment : { "name" : k, "value" : v }] : [])
  healthCheck = replace(jsonencode(var.healthCheck), local.classes["digit"], "$1")

  links = jsonencode(var.links)

  linuxParameters = replace(
    replace(
      replace(jsonencode(var.linuxParameters), "/\"1\"/", "true"),
      "/\"0\"/",
      "false",
    ),
    local.classes["digit"],
    "$1",
  )

  logConfiguration = jsonencode(var.logConfiguration)

  mountPoints = replace(
    replace(jsonencode(var.mountPoints), "/\"1\"/", "true"),
    "/\"0\"/",
    "false",
  )

  portMappings = replace(jsonencode(var.portMappings), local.classes["digit"], "$1")

  repositoryCredentials = jsonencode(var.repositoryCredentials)
  resourceRequirements  = jsonencode(var.resourceRequirements)
  secrets               = jsonencode(var.secrets)
  systemControls        = jsonencode(var.systemControls)

  ulimits = replace(jsonencode(var.ulimits), local.classes["digit"], "$1")

  volumesFrom = replace(
    replace(jsonencode(var.volumesFrom), "/\"1\"/", "true"),
    "/\"0\"/",
    "false",
  )

  # re2 ASCII character classes
  # https://github.com/google/re2/wiki/Syntax
  classes = {
    digit = "/\"(-[[:digit:]]|[[:digit:]]+)\"/"
  }

  container_definition = var.register_task_definition ? format("[%s]", data.template_file.container_definition.rendered) : format("%s", data.template_file.container_definition.rendered)

  container_definitions = replace(local.container_definition, "/\"(null)\"/", "$1")
}

data "template_file" "container_definition" {
  template = file("${path.module}/templates/container-definition.json.tpl")

  vars = {
    command                = local.command == "[]" ? "null" : local.command
    cpu                    = var.cpu == 0 ? "null" : var.cpu
    disableNetworking      = var.disableNetworking ? true : false
    dnsSearchDomains       = local.dnsSearchDomains == "[]" ? "null" : local.dnsSearchDomains
    dnsServers             = local.dnsServers == "[]" ? "null" : local.dnsServers
    dockerLabels           = local.dockerLabels == "{}" ? "null" : local.dockerLabels
    dockerSecurityOptions  = local.dockerSecurityOptions == "[]" ? "null" : local.dockerSecurityOptions
    entryPoint             = local.entryPoint == "[]" ? "null" : local.entryPoint
    environment            = local.environment == "[]" ? "null" : local.environment
    essential              = var.essential ? true : false
    extraHosts             = local.extraHosts == "[]" ? "null" : local.extraHosts
    healthCheck            = local.healthCheck == "{}" ? "null" : local.healthCheck
    hostname               = var.hostname == "" ? "null" : var.hostname
    image                  = var.image == "" ? "null" : var.image
    interactive            = var.interactive ? true : false
    links                  = local.links == "[]" ? "null" : local.links
    linuxParameters        = local.linuxParameters == "{}" ? "null" : local.linuxParameters
    logConfiguration       = local.logConfiguration == "{}" ? "null" : local.logConfiguration
    memory                 = var.memory == 0 ? "null" : var.memory
    memoryReservation      = var.memoryReservation == 0 ? "null" : var.memoryReservation
    mountPoints            = local.mountPoints == "[]" ? "null" : local.mountPoints
    name                   = var.name == "" ? "null" : var.name
    portMappings           = local.portMappings == "[]" ? "null" : local.portMappings
    privileged             = var.privileged ? true : false
    pseudoTerminal         = var.pseudoTerminal ? true : false
    readonlyRootFilesystem = var.readonlyRootFilesystem ? true : false
    repositoryCredentials  = local.repositoryCredentials == "{}" ? "null" : local.repositoryCredentials
    resourceRequirements   = local.resourceRequirements == "[]" ? "null" : local.resourceRequirements
    secrets                = local.secrets == "[]" ? "null" : local.secrets
    systemControls         = local.systemControls == "[]" ? "null" : local.systemControls
    ulimits                = local.ulimits == "[]" ? "null" : local.ulimits
    user                   = var.user == "" ? "null" : var.user
    volumesFrom            = local.volumesFrom == "[]" ? "null" : local.volumesFrom
    workingDirectory       = var.workingDirectory == "" ? "null" : var.workingDirectory
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  container_definitions = local.container_definitions
  execution_role_arn    = var.execution_role_arn
  family                = var.family
  ipc_mode              = var.ipc_mode
  network_mode          = var.network_mode
  pid_mode              = var.pid_mode

  # Fargate requires cpu and memory to be defined at the task level
  cpu    = var.cpu
  memory = var.memory

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }
  requires_compatibilities = var.requires_compatibilities
  task_role_arn            = var.task_role_arn
  dynamic "volume" {
    for_each = var.volumes
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      host_path = lookup(volume.value, "host_path", null)
      name      = volume.value.name

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }
      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory = lookup(efs_volume_configuration.value, "root_directory", null)
        }
      }
    }
  }
  tags = var.tags

  count = var.register_task_definition ? 1 : 0
}
