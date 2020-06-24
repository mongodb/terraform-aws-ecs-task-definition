environment = [
  {
    name  = "AWS_DEFAULT_REGION"
    value = "us-east-1"
  },
]

family = "default"

healthCheck = {
  command     = ["echo"]
  interval    = 30
  retries     = 3
  startPeriod = 0
  timeout     = 5
}

image = "mongo:3.6"

linuxParameters = {
  capabilities = {
    add  = ["AUDIT_CONTROL", "AUDIT_WRITE"]
    drop = ["SYS_RAWIO", "SYS_TIME"]
  }

  devices = [
    {
      containerPath = "/dev/disk0"
      hostPath      = "/dev/disk0"
      permissions   = ["read"]
    },
  ]

  initProcessEnabled = true
  sharedMemorySize   = 512

  tmpfs = [
    {
      containerPath = "/tmp"
      mountOptions  = ["defaults"]
      size          = 512
    },
  ]
}

logConfiguration = {
  logDriver = "awslogs"
  options = {
    awslogs-group  = "awslogs-mongodb"
    awslogs-region = "us-east-1"
  }
}

memoryReservation = 512

mountPoints = [
  {
    containerPath = "/dev/disk0"
    readOnly      = true
    sourceVolume  = "data"
  },
]

name = "mongo"

portMappings = [
  {
    containerPort = 8080
    hostPort      = 0
    protocol      = "tcp"
  },
]

ulimits = [
  {
    hardLimit = 1024
    name      = "cpu"
    softLimit = 1024
  },
]

user = "root"

volumes = [
  {
    name = "data"
  },
]

workingDirectory = "~/project"
