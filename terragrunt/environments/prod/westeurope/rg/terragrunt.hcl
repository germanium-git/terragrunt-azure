terraform {
  source = "${get_repo_root()}/terragrunt/modules/rg"
}

# Include root
include "root" {
  path = find_in_parent_folders("root.hcl")
  # expose = true # It is used to expose the locals from the include root block
}


locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # subscription_id = local.env_vars.locals.subscription_id
  region      = local.region_vars.locals.location
  environment     = local.env_vars.locals.environment
}

inputs = {
  rg_name         = "rg-${local.environment}-${local.region}"

  # location is inherited from the include root input block
  # location        = local.region                  # 2nd option to get the location from the local block
  # location        = include.root.locals.location  # 3rd option; It works only when the expose = true in the include root block

  # tags are inherited from the include root input block
}
