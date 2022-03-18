variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "eastus"
}
variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "dev"
}
variable "rg_name" {
  type        = string
  description = "The name of the resource group"
  default     = "MyResourceGroup"
}
variable "nsg_id" {
  type        = string
  description = "Resource ID of the NSG"
}
