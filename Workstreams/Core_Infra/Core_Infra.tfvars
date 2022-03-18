TagEnv = "Prod"
TagApp = "Terraform"

Nsg = {
  Name    = "nsgCoreNet",
  rg_Name = "rg_Terraform_Core",
  Region  = "EastUs2",
  Rules = [
    {
      name           = "ssh"
      priority       = 100
      direction      = "Inbound"
      access         = "Allow"
      protocol       = "TCP"
      source_port    = "*"
      dest_port      = "22"
      source_address = "*"
      dest_address   = "*"
    },
    {
      name           = "rdp"
      priority       = 200
      direction      = "Inbound"
      access         = "Allow"
      protocol       = "TCP"
      source_port    = "*"
      dest_port      = "3389"
      source_address = "*"
      dest_address   = "*"
    },
  ],
}

vNet = {
  Name     = "vNet_Hub_EastUs2",
  rg_Name  = "rg_Terraform_Core",
  Region   = "EastUs2",
  ip_Range = "10.17.0.0/24",
  Subnets = [
    {
      sub_Name  = "Hub",
      sub_Range = "10.17.0.0/25",
    },
    {
      sub_Name  = "GatewaySubnet",
      sub_Range = "10.17.0.128/25",
    }

  ],
}