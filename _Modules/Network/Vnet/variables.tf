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

#Vnet Specifics
variable "Vnet" {
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

variable "NsgId" {
  type        = string
  description = "Id of the NSG"
}