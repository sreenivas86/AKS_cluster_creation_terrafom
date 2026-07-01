resource "azuread_group" "aks_administtrator" {
  display_name     = " ${azurerm_resource_group.aks_rg.name}-cluster-administrators"
  security_enabled = true
  description      = " Azure Aks kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-cluster"
}