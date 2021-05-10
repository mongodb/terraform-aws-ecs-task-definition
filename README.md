![GitHub release](https://img.shields.io/github/release/mongodb/terraform-aws-ecs-task-definition.svg?style=flat-square) ![GitHub](https://img.shields.io/github/license/mongodb/terraform-aws-ecs-task-definition.svg?style=flat-square)

> A Terraform module for creating Amazon [ECS Task Definitions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)

## NOTICE

**THIS MODULE IS NOT COMPATIBLE WITH VERSIONS OF TERRAFORM LESS THAN v0.12.x. PLEASE REFER TO THE OFFICIAL [DOCUMENTATION](https://www.terraform.io/upgrade-guides/0-12.html) FOR UPGRADING TO THE LATEST VERSION OF TERRAFORM.**

## Contents

- [Motivation](#motivation)
  - [Use Cases](#use-cases)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Multiple Container Definitions](#multiple-container-definitions)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Testing](#testing)
- [License](#license)

## Motivation

The purpose of this module is to generate a valid Amazon [ECS Task Definition](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html) dynamically. A task definition is required to run Docker containers in Amazon ECS. A task definition contains a list of [container definitions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#container_definitions) received by the Docker daemon to create a container instance.

### Use Cases

- Have Terraform generate valid task definitions dynamically
- Update the ECS task definition and trigger new [service](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html) deployments automatically (see [examples/ecs_update_service.tf](examples/ecs_update_service.tf))

## Requirements

- [Terraform](https://www.terraform.io/downloads.html)
- [Go](https://golang.org/dl/) (for testing)

## Usage

This module uses the same parameters as the [`ContainerDefinition`](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html) object. Given the following Terraform configuration:

```hcl
provider "aws" {}

module "mongo-task-definition" {
  source = "github.com/mongodb/terraform-aws-ecs-task-definition"

  family = "mongo"
  image  = "mongo:3.6"
  memory = 512
  name   = "mongo"

  portMappings = [
    {
      containerPort = 27017
    },
  ]
}
```

Invoking the commands defined below creates an ECS task definition with the following [`containerDefinitions`](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_RegisterTaskDefinition.html#ECS-RegisterTaskDefinition-request-containerDefinitions):

    $ terraform init
    $ terraform apply

```json
[
  {
    "command": null,
    "cpu": null,
    "disableNetworking": false,
    "dnsSearchDomains": null,
    "dnsServers": null,
    "dockerLabels": null,
    "dockerSecurityOptions": null,
    "entryPoint": null,
    "environment": null,
    "essential": true,
    "extraHosts": null,
    "healthCheck": null,
    "hostname": null,
    "image": "mongo:3.6",
    "interactive": false,
    "links": null,
    "linuxParameters": null,
    "logConfiguration": null,
    "memory": 512,
    "memoryReservation": null,
    "mountPoints": null,
    "name": "mongo",
    "portMappings": [{"containerPort":27017}],
    "privileged": false,
    "pseudoTerminal": false,
    "readonlyRootFilesystem": false,
    "repositoryCredentials": null,
    "resourceRequirements": null,
    "secrets": null,
    "systemControls": null,
    "ulimits": null,
    "user": null,
    "volumesFrom": null,
    "workingDirectory": null
  }
]
```

### Multiple Container Definitions

By default, this module creates a task definition with a single container definition. To create a task definition with multiple container definitions, refer to the documentation of the [`merge`](modules/merge) module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [template_file.container_definition](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_command"></a> [command](#input\_command) | The command that is passed to the container | `list(string)` | `[]` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of cpu units reserved for the container | `number` | `0` | no |
| <a name="input_disableNetworking"></a> [disableNetworking](#input\_disableNetworking) | When this parameter is true, networking is disabled within the container | `bool` | `false` | no |
| <a name="input_dnsSearchDomains"></a> [dnsSearchDomains](#input\_dnsSearchDomains) | A list of DNS search domains that are presented to the container | `list(string)` | `[]` | no |
| <a name="input_dnsServers"></a> [dnsServers](#input\_dnsServers) | A list of DNS servers that are presented to the container | `list(string)` | `[]` | no |
| <a name="input_dockerLabels"></a> [dockerLabels](#input\_dockerLabels) | A key/value map of labels to add to the container | `map(string)` | `{}` | no |
| <a name="input_dockerSecurityOptions"></a> [dockerSecurityOptions](#input\_dockerSecurityOptions) | A list of strings to provide custom labels for SELinux and AppArmor multi-level security systems | `list(string)` | `[]` | no |
| <a name="input_entryPoint"></a> [entryPoint](#input\_entryPoint) | The entry point that is passed to the container | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment variables to pass to a container | `list(map(string))` | `[]` | no |
| <a name="input_essential"></a> [essential](#input\_essential) | If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped | `bool` | `true` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume | `string` | `""` | no |
| <a name="input_extraHosts"></a> [extraHosts](#input\_extraHosts) | A list of hostnames and IP address mappings to append to the /etc/hosts file on the container | <pre>list(object({<br>    ipAddress = string<br>    hostname  = string<br>  }))</pre> | `[]` | no |
| <a name="input_family"></a> [family](#input\_family) | You must specify a family for a task definition, which allows you to track multiple versions of the same task definition | `any` | n/a | yes |
| <a name="input_healthCheck"></a> [healthCheck](#input\_healthCheck) | The health check command and associated configuration parameters for the container | `any` | `{}` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname to use for your container | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | The image used to start a container | `string` | `""` | no |
| <a name="input_interactive"></a> [interactive](#input\_interactive) | When this parameter is true, this allows you to deploy containerized applications that require stdin or a tty to be allocated | `bool` | `false` | no |
| <a name="input_ipc_mode"></a> [ipc\_mode](#input\_ipc\_mode) | The IPC resource namespace to use for the containers in the task | `any` | `null` | no |
| <a name="input_links"></a> [links](#input\_links) | The link parameter allows containers to communicate with each other without the need for port mappings | `list(string)` | `[]` | no |
| <a name="input_linuxParameters"></a> [linuxParameters](#input\_linuxParameters) | Linux-specific modifications that are applied to the container, such as Linux KernelCapabilities | `any` | `{}` | no |
| <a name="input_logConfiguration"></a> [logConfiguration](#input\_logConfiguration) | The log configuration specification for the container | `any` | `{}` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The hard limit (in MiB) of memory to present to the container | `number` | `512` | no |
| <a name="input_memoryReservation"></a> [memoryReservation](#input\_memoryReservation) | The soft limit (in MiB) of memory to reserve for the container | `number` | `0` | no |
| <a name="input_mountPoints"></a> [mountPoints](#input\_mountPoints) | The mount points for data volumes in your container | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of a container | `string` | `""` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | The Docker networking mode to use for the containers in the task | `string` | `"bridge"` | no |
| <a name="input_pid_mode"></a> [pid\_mode](#input\_pid\_mode) | The process namespace to use for the containers in the task | `any` | `null` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | An array of placement constraint objects to use for the task | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| <a name="input_portMappings"></a> [portMappings](#input\_portMappings) | The list of port mappings for the container | `list(any)` | `[]` | no |
| <a name="input_privileged"></a> [privileged](#input\_privileged) | When this parameter is true, the container is given elevated privileges on the host container instance (similar to the root user) | `bool` | `false` | no |
| <a name="input_pseudoTerminal"></a> [pseudoTerminal](#input\_pseudoTerminal) | When this parameter is true, a TTY is allocated | `bool` | `false` | no |
| <a name="input_readonlyRootFilesystem"></a> [readonlyRootFilesystem](#input\_readonlyRootFilesystem) | When this parameter is true, the container is given read-only access to its root file system | `bool` | `false` | no |
| <a name="input_register_task_definition"></a> [register\_task\_definition](#input\_register\_task\_definition) | Registers a new task definition from the supplied family and containerDefinitions | `bool` | `true` | no |
| <a name="input_repositoryCredentials"></a> [repositoryCredentials](#input\_repositoryCredentials) | The private repository authentication credentials to use | `map(string)` | `{}` | no |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | The launch type required by the task | `list(string)` | `[]` | no |
| <a name="input_resourceRequirements"></a> [resourceRequirements](#input\_resourceRequirements) | The type and amount of a resource to assign to a container | `list(string)` | `[]` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | The secrets to pass to the container | `list(map(string))` | `[]` | no |
| <a name="input_systemControls"></a> [systemControls](#input\_systemControls) | A list of namespaced kernel parameters to set in the container | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The metadata that you apply to the task definition to help you categorize and organize them | `map(string)` | `{}` | no |
| <a name="input_taskCpu"></a> [taskCpu](#input\_taskCpu) | The number of cpu units limited for the task. Required for Fargate. _null_ to disable | `number` | `256` | no |
| <a name="input_taskMemory"></a> [taskMemory](#input\_taskMemory) | Memory (in MiB) for the task. Required for Fargate. _null_ to disable | `number` | `256` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume | `string` | `""` | no |
| <a name="input_ulimits"></a> [ulimits](#input\_ulimits) | A list of ulimits to set in the container | `list(any)` | `[]` | no |
| <a name="input_user"></a> [user](#input\_user) | The user name to use inside the container | `string` | `""` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | A list of volume definitions in JSON format that containers in your task may use | `list(any)` | `[]` | no |
| <a name="input_volumesFrom"></a> [volumesFrom](#input\_volumesFrom) | Data volumes to mount from another container | <pre>list(object({<br>    readOnly        = bool<br>    sourceContainer = string<br>  }))</pre> | `[]` | no |
| <a name="input_workingDirectory"></a> [workingDirectory](#input\_workingDirectory) | The working directory in which to run commands inside the container | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The full Amazon Resource Name (ARN) of the task definition |
| <a name="output_container_definitions"></a> [container\_definitions](#output\_container\_definitions) | A list of container definitions in JSON format that describe the different containers that make up your task |
| <a name="output_family"></a> [family](#output\_family) | The family of your task definition, used as the definition name |
| <a name="output_revision"></a> [revision](#output\_revision) | The revision of the task in a particular family |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing

This module uses [Terratest](https://github.com/gruntwork-io/terratest), a Go library maintained by [Gruntwork](https://gruntwork.io/), to write automated tests for your infrastructure code. To invoke tests, run the following commands:

    $ go test -v ./...

## License

[Apache License 2.0](LICENSE)
