variable "rg_Name" {
  type        = string
  description = "The name of the resource group"
  default     = "MyResourceGroup"
}

variable "Region" {
  type        = string
  description = "The Azure region for your resources"
  validation {
    condition     = contains(["CentralUs", "EastUs", "EastUs2", "WestUs", "NorthCentralUs", "SouthCentralUs", "WestCentralUs", "WestUs2"], var.Region)
    error_message = "Please use a valid value for the Region.  See variable.tf for valid values."
  }
  default = "EastUS2"
}

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
