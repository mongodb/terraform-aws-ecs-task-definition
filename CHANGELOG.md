## [2.0.1](https://github.com/mongodb/terraform-aws-ecs-task-definition/compare/v2.0.0...v2.0.1) (2020-03-21)


### Bug Fixes

* update type of logConfiguration variable ([#27](https://github.com/mongodb/terraform-aws-ecs-task-definition/issues/27)) ([041b144](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/041b1445f074dfa3205da1a32d5f91496449f728)), closes [#26](https://github.com/mongodb/terraform-aws-ecs-task-definition/issues/26)

# [2.0.0](https://github.com/mongodb/terraform-aws-ecs-task-definition/compare/v1.2.1...v2.0.0) (2020-03-19)


### Features

* upgrade module to support Terraform 0.12.x ([#24](https://github.com/mongodb/terraform-aws-ecs-task-definition/issues/24)) ([8998443](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/899844342323285fb5c4cac4f4bc80c9b31dcdc5))


### BREAKING CHANGES

* This module no longer supports Terraform versions 0.11.x. Please upgrade
your version of Terraform and run the `0.12upgrade` command. Visit the
following URL for more information:

    https://www.terraform.io/docs/commands/0.12upgrade.html

* fix: change Terraform download URL to latest in CI

## [1.2.1](https://github.com/mongodb/terraform-aws-ecs-task-definition/compare/v1.2.0...v1.2.1) (2019-12-24)


### Bug Fixes

* add checkout step to CircleCI config ([d40ec70](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/d40ec709706d7bfafce8c15eaf3f8915af3d424f))
* begin updating CI config ([1f223b9](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/1f223b93aa62bd76607a4d31a8d55fe5e17d1ca8))
* remove nested job directive from CI config ([958615c](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/958615c4547f163752560760b2ca3f0477f52e5f))

# [1.2.0](https://github.com/mongodb/terraform-aws-ecs-task-definition/compare/v1.1.0...v1.2.0) (2019-04-16)


### Features

* Add support for multiple containers ([a7377e2](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/a7377e2)), closes [#9](https://github.com/mongodb/terraform-aws-ecs-task-definition/issues/9)

# [1.1.0](https://github.com/mongodb/terraform-aws-ecs-task-definition/compare/v1.0.1...v1.1.0) (2019-04-11)


### Features

* Add register_task_definition input ([430b1bf](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/430b1bf))

## [1.0.1](https://github.com/mongodb/terraform-aws-ecs-task-definition/compare/v1.0.0...v1.0.1) (2019-04-09)


### Bug Fixes

* Support negative values for ulimits ([ca6f022](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/ca6f022))

# 1.0.0 (2019-04-09)


### Features

* Use semantic release for GitHub releases ([be3151d](https://github.com/mongodb/terraform-aws-ecs-task-definition/commit/be3151d))
