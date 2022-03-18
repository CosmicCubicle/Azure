terraform {
  backend "azurerm" {
    storage_account_name = "msclass42b41d0ce0354e82"
    container_name       = "terraformstate"
    key                  = "prod.terraform.tfstate"
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