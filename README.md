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
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| command | The command that is passed to the container | `list(string)` | `[]` | no |
| cpu | The number of cpu units reserved for the container | `number` | `0` | no |
| disableNetworking | When this parameter is true, networking is disabled within the container | `bool` | `false` | no |
| dnsSearchDomains | A list of DNS search domains that are presented to the container | `list(string)` | `[]` | no |
| dnsServers | A list of DNS servers that are presented to the container | `list(string)` | `[]` | no |
| dockerLabels | A key/value map of labels to add to the container | `map(string)` | `{}` | no |
| dockerSecurityOptions | A list of strings to provide custom labels for SELinux and AppArmor multi-level security systems | `list(string)` | `[]` | no |
| entryPoint | The entry point that is passed to the container | `list(string)` | `[]` | no |
| environment | The environment variables to pass to a container | `list(map(string))` | `[]` | no |
| essential | If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped | `bool` | `true` | no |
| execution\_role\_arn | The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume | `string` | `""` | no |
| extraHosts | A list of hostnames and IP address mappings to append to the /etc/hosts file on the container | `list(string)` | `[]` | no |
| family | You must specify a family for a task definition, which allows you to track multiple versions of the same task definition | `any` | n/a | yes |
| healthCheck | The health check command and associated configuration parameters for the container | `any` | `{}` | no |
| hostname | The hostname to use for your container | `string` | `""` | no |
| image | The image used to start a container | `string` | `""` | no |
| interactive | When this parameter is true, this allows you to deploy containerized applications that require stdin or a tty to be allocated | `bool` | `false` | no |
| ipc\_mode | The IPC resource namespace to use for the containers in the task | `string` | `"host"` | no |
| links | The link parameter allows containers to communicate with each other without the need for port mappings | `list(string)` | `[]` | no |
| linuxParameters | Linux-specific modifications that are applied to the container, such as Linux KernelCapabilities | `any` | `{}` | no |
| logConfiguration | The log configuration specification for the container | `any` | `{}` | no |
| memory | The hard limit (in MiB) of memory to present to the container | `number` | `0` | no |
| memoryReservation | The soft limit (in MiB) of memory to reserve for the container | `number` | `0` | no |
| mountPoints | The mount points for data volumes in your container | `list(any)` | `[]` | no |
| name | The name of a container | `string` | `""` | no |
| network\_mode | The Docker networking mode to use for the containers in the task | `string` | `"bridge"` | no |
| pid\_mode | The process namespace to use for the containers in the task | `string` | `"host"` | no |
| placement\_constraints | An array of placement constraint objects to use for the task | `list(string)` | `[]` | no |
| portMappings | The list of port mappings for the container | `list(any)` | `[]` | no |
| privileged | When this parameter is true, the container is given elevated privileges on the host container instance (similar to the root user) | `bool` | `false` | no |
| pseudoTerminal | When this parameter is true, a TTY is allocated | `bool` | `false` | no |
| readonlyRootFilesystem | When this parameter is true, the container is given read-only access to its root file system | `bool` | `false` | no |
| register\_task\_definition | Registers a new task definition from the supplied family and containerDefinitions | `bool` | `true` | no |
| repositoryCredentials | The private repository authentication credentials to use | `map(string)` | `{}` | no |
| requires\_compatibilities | The launch type required by the task | `list(string)` | `[]` | no |
| resourceRequirements | The type and amount of a resource to assign to a container | `list(string)` | `[]` | no |
| secrets | The secrets to pass to the container | `list(string)` | `[]` | no |
| systemControls | A list of namespaced kernel parameters to set in the container | `list(string)` | `[]` | no |
| tags | The metadata that you apply to the task definition to help you categorize and organize them | `map(string)` | `{}` | no |
| task\_role\_arn | The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume | `string` | `""` | no |
| ulimits | A list of ulimits to set in the container | `list(any)` | `[]` | no |
| user | The user name to use inside the container | `string` | `""` | no |
| volumes | A list of volume definitions in JSON format that containers in your task may use | `list(any)` | `[]` | no |
| volumesFrom | Data volumes to mount from another container | `list(string)` | `[]` | no |
| workingDirectory | The working directory in which to run commands inside the container | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The full Amazon Resource Name (ARN) of the task definition |
| container\_definitions | A list of container definitions in JSON format that describe the different containers that make up your task |
| family | The family of your task definition, used as the definition name |
| revision | The revision of the task in a particular family |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing

This module uses [Terratest](https://github.com/gruntwork-io/terratest), a Go library maintained by [Gruntwork](https://gruntwork.io/), to write automated tests for your infrastructure code. To invoke tests, run the following commands:

    $ go test -v ./...

## License

[Apache License 2.0](LICENSE)
