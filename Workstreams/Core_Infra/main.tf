terraform {
  backend "azurerm" {
    storage_account_name = "strterraform41f2da44"
    container_name       = "terraformstate"
    key                  = "Core_Infra.tfstate"
  }
}

provider "azurerm" {
  features {

  }
}

locals {
}

module "Nsg" {
  source = "../Modules/Network/Nsg"
  Nsg    = var.Nsg
  TagApp = var.TagApp
  TagEnv = var.TagEnv
}

module "vNet" {
  source = "../Modules/Network/vNet"
  vNet   = var.vNet
  NsgId  = module.Nsg.NsgObj.id
  TagApp = var.TagApp
  TagEnv = var.TagEnv
  depends_on = [
    module.Nsg
  ]
}