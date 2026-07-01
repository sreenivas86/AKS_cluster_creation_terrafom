variable "location" {
  type        = string
  description = "Azure region where all these resources provisioned"
  default     = "Central US"

}
variable "resource_group_name" {
  type        = string
  description = "This variable defines name of Resource group"
  default     = "terraform-aks"
}
variable "environment" {
  type        = string
  description = "this variable defiens the environment"
  default     = "dev"
}
# AKS input variables
# SSH public key for linux vms
variable "ssh_publi_key" {
  default     = "~/.ssh/aksprodsshkey.pub"
  description = "this variable defines the ssh public key for linux k8s worker node"

}
# Windows admin username for worker nodes
variable "windows_admin_username" {
  type        = string
  default     = "azureuser"
  description = "this variable defines the windows username"
}
# windows admin password for k8s worker nodes
variable "windows_admin_password" {
  type        = string
  default     = "Sreenu@1234"
  description = "this variable define the windows admin password"

}