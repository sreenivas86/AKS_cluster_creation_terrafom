# Terraform settings block
terraform {

  required_version = ">=1.15"
  required_providers {
    # azurerm lets us manage the azure resources
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    # azuread lets us manage users and permissions
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.0 "
    }
    # random module create random names over all azure resources
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }




  }
  # Terraform state storage to azure storage container
  backend "azurerm" {
    resource_group_name  = "terraform-storage-rg"
    storage_account_name = "< storage account name>"
    container_name       = "< name of the container >"
    key                  = "dev.terraform.tfstate"

  }

}
provider "azurerm" {
  subscription_id = "< id> "
  features {

  }
}
resource "random_pet" "aksrandom" {

}