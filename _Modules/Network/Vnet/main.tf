locals {
}

resource "azurerm_virtual_network" "vNet" {
  name                = var.Vnet.Name
  address_space       = [var.Vnet.ip_Range]
  location            = var.Vnet.Region
  resource_group_name = var.Vnet.rg_Name

  dynamic "subnet" {
    for_each = var.vNet.Subnets

    content {
      name           = subnet.value.sub_Name
      address_prefix = subnet.value.sub_Range
      security_group = subnet.value.sub_Name != "GatewaySubnet" ? var.NsgId : null
    }
  }

  tags = {
    Environment = var.TagEnv
    Application = var.TagApp
  }

}
