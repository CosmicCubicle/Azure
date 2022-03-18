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

variable "Nsg" {
  description = "The NSG object to be created"
  type = object({
    Name    = string
    rg_Name = string
    Region  = string
    Rules = list(object({
      name           = string
      priority       = number
      direction      = string
      access         = string
      protocol       = string
      source_port    = string
      dest_port      = string
      source_address = string
      dest_address   = string
    }))
  })
}

variable "vNet" {
  description = "The vNet object to be created"
  type = object({
    Name     = string
    rg_Name  = string
    Region   = string
    ip_Range = string
    Subnets = list(object({
      sub_Name  = string
      sub_Range = string
    }))
  })
}
