# create outputs for
# 1. resource group location
# 2. resource group id
# 3. resource group name

# resource group outputs
output "location" {
    value = azurerm_resource_group.aks_rg.location
  
}
output "resource_group_id"{
    value = azurerm_resource_group.aks_rg.id
}
output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
}
# Azure AKS versions Datasources

output "versions" {
    value = data.azurerm_kubernetes_service_versions.current.versions
  
}
output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}
# output AzureAD
output "azure_ad_group_id" {
  value = azuread_group.aks_administtrator.id
}
output "azure_ad_group_objectid" {
  value = azuread_group.aks_administtrator.object_id
}
# Azure Aks outputs
output "aks_cluster_id" {
    value = azurerm_kubernetes_cluster.aks_cluster.aks_cluster_id
}
output "aks_cluster_name"{
    value = azurerm_kubernetes_cluster.aks_cluster.aks_cluster_name
}
output "aks_cluster_kubernetes_version"{
    value = azurerm_kubernetes_cluster.aks_cluster.aks_cluster_kubernetes_version
}