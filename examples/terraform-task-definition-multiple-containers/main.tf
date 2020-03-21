module "mongodb" {
  source = "../.."

  family = "mongodb"
  image  = "mongo:3.6"
  memory = 512
  name   = "mongodb"

  portMappings = [
    {
      containerPort = 27017
      protocol      = "TCP"
    },
  ]

  register_task_definition = false
}

module "redis" {
  source = "../.."

  family = "redis"
  image  = "redis:alpine"
  memory = 512

  logConfiguration = {
    logDriver = "awslogs"
    options = {
      awslogs-group  = "awslogs-mongodb"
      awslogs-region = "us-east-1"
    }
  }

  name = "redis"

  portMappings = [
    {
      containerPort = 6379
      protocol      = "TCP"
    },
  ]

  register_task_definition = false
}

module "merged" {
  source = "../../modules/merge"

  container_definitions = [
    module.mongodb.container_definitions,
    module.redis.container_definitions,
  ]
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  container_definitions = module.merged.container_definitions
  family                = "app"
}
