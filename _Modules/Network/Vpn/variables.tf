##Tags
variable "TagEnv" {
  type        = string
  description = "The Environment tag"
  validation {
    condition     = contains(["Dev", "Prod", "Test"], var.TagEnv)
    error_message = "Please use a valid value for the Environment Type.  See variable.tf for valid values."
  }
  default = "Dev"
}

variable "TagApp" {
  type        = string
  description = "The App tag"
}

##Core Info
variable "Rg_Name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "Region" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}


##VPN Specific
variable "Vnet" {
  description = "The virtual network"
  type = object({
    name    = string
    rg_name = string
  })
}

variable "Pip_Id" {
  description = "The Resource Id of the Public Ip"
  default     = ""
}

variable "VnetGw" {
  description = "The VPN Gateway object to be created"
  type = object({
    Name         = string
    GwType       = string
    GwSku        = string
    VpnType      = string
    VpnGen       = string
    ActiveActive = bool
    Bgp = list(object({
      enable      = bool
      asn         = number
      peeraddress = string
      peerweight  = number
    }))
    ExpressRoute = object({
      sku = string
    })
  })
}

##Local Network Gateway Specific
variable "LocalGw" {
  description = "The Local Gateway object to be created"
  type = object({
    Name            = string
    Gateway_Address = string
    Address_Space   = string
    Bgp = list(object({
      enable      = bool
      asn         = number
      peeraddress = string
      peerweight  = number
    }))
  })
}

##Connection Specific
variable "GwConnection" {
  description = "The Gateway Connection object to be created"
  type = object({
    Name            = string
    Type            = string
    ExpressRoute_Id = string
    Protocol        = string
    LocalNetworks = list(object({
      gw_name       = string
      gw_address    = string
      address_space = string
      shared_key    = string
    }))
  })
}