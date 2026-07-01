# Datasource to get latest version 
# Reference Documentation: `https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_service_versions`
data "azurerm_kubernetes_service_versions" "current" {
  location        = azurerm_resource_group.aks_rg.location
  include_preview = false

}