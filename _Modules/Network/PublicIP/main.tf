locals {
}

resource "azurerm_public_ip" "PublicIp" {
  name                = var.IpName
  resource_group_name = var.rg_Name
  location            = var.Region
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "global"

  tags = {
    Environment = var.TagEnv
    Application = var.TagApp
  }
}