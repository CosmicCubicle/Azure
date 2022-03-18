locals {
}

resource "azurerm_network_security_group" "Nsg" {
  name                = var.Nsg.Name
  location            = var.Nsg.Region
  resource_group_name = var.Nsg.Rg_Name

  dynamic "security_rule" {
    for_each = var.Nsg.Rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port
      destination_port_range     = security_rule.value.dest_port
      source_address_prefix      = security_rule.value.source_address
      destination_address_prefix = security_rule.value.dest_address
    }
  }
  tags = {
    Environment = var.TagEnv
    Application = var.TagApp
  }

}
