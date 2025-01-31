locals {
  subscription_id = "22222222-2222-2222-2222-222222222222"
  environment     = "prod"
  azurerm_version = "4.17.0"
  env_tags = {
    environment = local.environment
  }
}