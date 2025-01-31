terraform {
  source = "${get_repo_root()}/terragrunt/modules/vnet"
}

dependency "rg" {
  config_path = "../rg"

  mock_outputs = {
    rg_name     = "rg-mock"
    rg_location = "westeurope"
  }
}

# Include root
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment = local.env_vars.locals.environment

}

inputs = {
  vnet_name           = "${local.environment}-vnet"
  location            = dependency.rg.outputs.rg_location
  resource_group_name = dependency.rg.outputs.rg_name
  address_space       = ["10.0.0.0/16"]

  subnets = {
    "subnet1" = ["10.0.1.0/24"]
    "subnet2" = ["10.0.2.0/24"]
  }

  # tags are inherited from the include root input block
  # tags = local.tags
}
