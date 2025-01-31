locals {
  subscription_id = "11111111-1111-1111-1111-111111111111"
  environment     = "dev"
  azurerm_version = "4.17.0"
  env_tags = {
    environment = local.environment
  }
}
