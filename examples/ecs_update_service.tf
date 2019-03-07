# This configuration demonstrates forcing the new deployment of an ECS
# service if there is a change to the ECS task definition. The
# configuration uses the `null_resource` provider to invoke the
# `local-exec` provisioner whenever the task definition ARN changes.
#
# To force a new deployment even if there are no changes made to the
# task definition, `taint` the resource:
#
#  $ terraform taint null_resource.update-service

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

resource "aws_ecs_service" "mongo" {
  cluster         = "mongo"
  name            = "mongo"
  task_definition = "${module.mongo-task-definition.arn}"
}

resource "null_resource" "update-service" {
  triggers = {
    arn = "${module.mongo-task-definition.arn}"
  }

  provisioner "local-exec" {
    command = "aws ecs update-service --cluster ${aws_ecs_service.mongo.cluster} --service ${aws_ecs_service.mongo.name} --task-definition ${module.mongo-task-definition.arn} --force-new-deployment"
  }
}
