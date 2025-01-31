# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform/OpenTofu that provides extra tools for working with multiple modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load global-level variables
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  location        = local.region_vars.locals.location
  environment     = local.environment_vars.locals.environment
  subscription_id = local.environment_vars.locals.subscription_id
  azurerm_version = local.environment_vars.locals.azurerm_version

  tags = merge(
    local.global_vars.locals.common_tags,
    local.environment_vars.locals.env_tags,
    local.region_vars.locals.region_tags
  )
}

# Generate Azure providers
generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "${local.azurerm_version}"
        }
      }
    }

    provider "azurerm" {
        features {}
        subscription_id = "${local.subscription_id}"
    }
EOF
}

remote_state {
  backend = "azurerm"
  config = {
    subscription_id      = "ef3d774b-ace6-4471-a1b7-94d751d415cf"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = "rg-terraform-platformteam"
    storage_account_name = "satfplatform"
    container_name       = "terragrunttfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals,
  local.global_vars.locals,
  {
    tags = local.tags
  }
)
