resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  zones = [1,2,3]
  auto_scaling_enabled = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  max_count = "3"
  min_count = "1"
  mode = "User"
  name = "linux101"
  orchestrator_version = data.azurerm_kubernetes_service_versions.latest_version
  os_disk_size_gb = 30
  os_type = "Linux"
  vm_size = "Standard_DS2_V2"
  priority = "Regular"
  vnet_subnet_id = azurerm_subnet.aks-default.id
  node_labels = {
    "nodepool-type"= "user"
    "environment" = var.environment
    "nodepoolos" = "linux"
    "app" = "java-apps"
  }
  tags = { 
    "nodepool-type"= "user"
    "environment" = var.environment
    "nodepoolos" = "linux"
    "app" = "java-apps"
   }
  
}