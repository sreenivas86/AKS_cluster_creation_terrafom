# terraform resource to create azure resource group with input variables defined in variable.tf
resource "azurerm_resource_group" "aks_rg" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location

}