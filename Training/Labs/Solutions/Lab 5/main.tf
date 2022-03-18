terraform {
  backend "azurerm" {
    storage_account_name = "msclass42b41d0ce0354e82"
    container_name       = "terraformstate"
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
  }
}

data "azurerm_resource_group" "main" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {

}

module "my-frontend-module" {
  source = "./my-frontend-module"

  location    = var.location
  environment = var.environment
  rg_name     = data.azurerm_resource_group.main.name
}
