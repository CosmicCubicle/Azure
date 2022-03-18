data "azurerm_subnet" "sub_gateway" {
  name                 = "GatewaySubnet"
  virtual_network_name = var.Vnet.name
  resource_group_name  = var.Vnet.rg_name
}

#-------------------------------
# Virtual Network Gateway 
#-------------------------------
resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.VnetGw.Name
  resource_group_name = var.Rg_Name
  location            = var.Region
  type                = var.VnetGw.GwType
  vpn_type            = var.VnetGw.VpnType != "ExpressRoute" ? var.vpn_type : null
  sku                 = var.VnetGw.VpnType != "ExpressRoute" ? var.VnetGw.GwSku : var.VnetGw.ExpressRoute.sku
  active_active       = var.VnetGw.GwSku != "Basic" ? var.VnetGw.ActiveActive : false
  enable_bgp          = var.VnetGw.GwSku != "Basic" ? var.VnetGw.Bgp.enable : false
  generation          = var.VnetGw.VpnGen


  dynamic "bgp_settings" {
    for_each = var.VnetGw.Bgp.enable ? [true] : []
    content {
      asn             = var.VnetGw.Bgp.asn
      peering_address = var.VnetGw.Bgp.peeraddress
      peer_weight     = var.VnetGw.Bgp.peerweight
    }
  }

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.Pip_Id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.sub_gateway.id
  }

  dynamic "ip_configuration" {
    for_each = var.enable_active_active ? [true] : []
    content {
      name                          = "vnetVpnGateway"
      public_ip_address_id          = var.Pip_Id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = data.azurerm_subnet.snet.id
    }
  }
}

#---------------------------
# Local Network Gateway
#---------------------------
resource "azurerm_local_network_gateway" "localgw" {
  name                = var.LocalGw.Name
  resource_group_name = var.Rg_Name
  location            = var.Region
  gateway_address     = var.LocalGw.Gateway_Address
  address_space       = var.LocalGw.Address_Space

  dynamic "bgp_settings" {
    for_each = var.LocalGw.Bgp.enable ? [true] : []
    content {
      asn             = var.LocalGw.Bgp.asn
      peering_address = var.LocalGw.Bgp.peeraddress
      peer_weight     = var.LocalGw.Bgp.peerweight
    }
  }

  tags = {
    Environment = var.TagEnv
    Application = var.TagApp
  }

}

#---------------------------------------
# Virtual Network Gateway Connection
#---------------------------------------
resource "azurerm_virtual_network_gateway_connection" "az-hub-onprem" {
  count                           = var.gateway_connection_type == "ExpressRoute" ? 1 : length(var.local_networks)
  name                            = var.gateway_connection_type == "ExpressRoute" ? "localgw-expressroute-connection" : "localgw-connection-${var.local_networks[count.index].local_gw_name}"
  resource_group_name             = var.Rg_Name
  location                        = var.Region
  type                            = var.gateway_connection_type
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id        = var.gateway_connection_type != "ExpressRoute" ? azurerm_local_network_gateway.localgw[count.index].id : null
  express_route_circuit_id        = var.gateway_connection_type == "ExpressRoute" ? var.express_route_circuit_id : null
  peer_virtual_network_gateway_id = var.gateway_connection_type == "Vnet2Vnet" ? var.peer_virtual_network_gateway_id : null
  shared_key                      = var.gateway_connection_type != "ExpressRoute" ? var.local_networks[count.index].shared_key : null
  connection_protocol             = var.gateway_connection_type == "IPSec" && var.vpn_gw_sku == ["VpnGw1", "VpnGw2", "VpnGw3", "VpnGw1AZ", "VpnGw2AZ", "VpnGw3AZ"] ? var.gateway_connection_protocol : null

  dynamic "ipsec_policy" {
    for_each = var.local_networks_ipsec_policy != null ? [true] : []
    content {
      dh_group         = var.local_networks_ipsec_policy.dh_group
      ike_encryption   = var.local_networks_ipsec_policy.ike_encryption
      ike_integrity    = var.local_networks_ipsec_policy.ike_integrity
      ipsec_encryption = var.local_networks_ipsec_policy.ipsec_encryption
      ipsec_integrity  = var.local_networks_ipsec_policy.ipsec_integrity
      pfs_group        = var.local_networks_ipsec_policy.pfs_group
      sa_datasize      = var.local_networks_ipsec_policy.sa_datasize
      sa_lifetime      = var.local_networks_ipsec_policy.sa_lifetime
    }
  }
  tags = merge({ "ResourceName" = var.gateway_connection_type == "ExpressRoute" ? "localgw-expressroute-connection" : "localgw-connection-${var.local_networks[count.index].local_gw_name}" }, var.tags, )
}