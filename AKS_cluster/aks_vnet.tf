# Azure Vnet for AKS
# Reference document: `https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network`
resource "azurerm_virtual_network" "aksvnet" {
  name = "aks-network"
  location = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  address_space = ["10.0.0.0/8"]
  
}

# Azure Subnet for AKS
# reference document: `https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet`

resource "azurerm_subnet" "aks-default" {
  name = "aks-default-subnet"
  resource_group_name = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  address_prefixes = ["10.0.0.0/24"]
}