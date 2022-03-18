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

locals {
  environment = var.environment
  vm = {
    computer_name = var.vm_name
    user_name     = "admin1234"
  }
}

data "azurerm_resource_group" "main" {
  name = var.rg_name
}

data "azurerm_client_config" "current" {
}

data "azurerm_key_vault_secret" "main" {
  name         = var.admin_pw_name
  key_vault_id = var.key_vault_resource_id
}

module "vnet" {
  source = "./Modules/Network/VirtualNetwork"
  depends_on = [
    module.nsg
  ]
  location    = var.location
  environment = local.environment
  rg_name     = data.azurerm_resource_group.main.name
  nsg_id      = module.nsg.id_out
}

module "nsg" {
  source      = "./Modules/Network/NetworkSecurityGroup"
  location    = var.location
  environment = local.environment
  rg_name     = data.azurerm_resource_group.main.name
  port        = 22
}

module "vm" {
  source      = "./Modules/Compute/VirtualMachines"
  location    = var.location
  environment = local.environment
  rg_name     = data.azurerm_resource_group.main.name
  vm_name     = var.vm_name
  subnet      = module.vnet.subnet_id
  password    = data.azurerm_key_vault_secret.main.value
  user        = local.vm.user_name
}

