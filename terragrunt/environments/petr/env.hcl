locals {
  subscription_id = "2595681a-fd83-4124-9977-3869de3e85cf"
  environment     = "petr"
  azurerm_version = "4.17.0"
  env_tags = {
    environment = local.environment
  }
}
