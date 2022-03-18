provider "azurerm" {
  skip_provider_registration = true
  features {
  }
}

locals {
  TerraformStorage = "strterraform"
  VaultName        = "kvtCosmicCubicle"
}

data "azurerm_client_config" "current" {
}

resource "random_id" "storage_account" {
  byte_length = 4
}

resource "azurerm_resource_group" "rgSetup" {
  name     = var.rg_Name
  location = var.Region
  tags = {
    Environment = var.TagEnv
    Application = var.TagApp
  }
}

resource "azurerm_storage_account" "tf_storage" {
  name                     = "${local.TerraformStorage}${lower(random_id.storage_account.hex)}"
  location                 = var.Region
  resource_group_name      = azurerm_resource_group.rgSetup.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.rgSetup]

  tags = {
    Environment = var.TagEnv
    Application = var.TagApp
  }

}

resource "azurerm_key_vault" "vault" {
  name                            = local.VaultName
  location                        = azurerm_resource_group.rgSetup.location
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  resource_group_name             = azurerm_resource_group.rgSetup.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Create",
      "Delete",
      "Get",
      "Import",
      "List",
      "Update",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ListIssuers",
      "ManageIssuers",
      "SetIssuers",
      "GetIssuers",
      "DeleteIssuers",
    ]

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    secret_permissions = [
      "Get",
      "Delete",
      "List",
      "Set",
      "Recover",
      "Backup",
      "Restore",
    ]

    storage_permissions = [
      "get",
    ]
  }

  tags = {
    Environment = var.TagEnv
    Application = var.TagApp
  }

}

resource "azurerm_key_vault_secret" "secret" {
  name         = "terraform"
  value        = azurerm_storage_account.tf_storage.primary_access_key
  key_vault_id = azurerm_key_vault.vault.id
  depends_on   = [azurerm_storage_account.tf_storage]
}

resource "azurerm_storage_container" "terraformstate" {
  name                  = "terraformstate"
  storage_account_name  = azurerm_storage_account.tf_storage.name
  container_access_type = "private"
}
