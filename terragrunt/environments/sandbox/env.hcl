locals {
  subscription_id = "ef3d774b-ace6-4471-a1b7-94d751d415cf"
  environment     = "sandbox"
  azurerm_version = "4.17.0"
  env_tags = {
    environment = local.environment
  }
}