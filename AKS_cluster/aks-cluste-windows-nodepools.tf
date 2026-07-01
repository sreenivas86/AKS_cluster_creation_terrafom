resource "azurerm_kubernetes_cluster_node_pool" "win101" {
  zones = [1,2,3]
  auto_scaling_enabled = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  max_count = "3"
  min_count = "1"
  mode = "User"
  name = "win101"
  orchestrator_version = data.azurerm_kubernetes_service_versions.latest_version
  os_disk_size_gb = 60
  os_type = "Windows"
  vm_size = "Standard_DS2_v2"
  priority = "Regular"
  node_labels = {
    "nodepool-type"= "user"
    "environment" = var.environment
    "nodepoolos" = "windows"
    "app" = "dotnet-apps"
  }
  tags = { 
    "nodepool-type"= "user"
    "environment" = var.environment
    "nodepoolos" = "windows"
    "app" = "dotnet-apps"
   }
}