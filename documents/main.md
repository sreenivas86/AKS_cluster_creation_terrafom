# Terraform Configuration Documentation

This document explains the Terraform configuration used to deploy Azure resources. It covers the Terraform settings, required providers, backend configuration, and Azure provider setup.

---

# Overview

The configuration includes:

- Terraform version constraint
- Required providers
  - AzureRM
  - AzureAD
  - Random
- Azure Storage backend for Terraform state
- AzureRM provider configuration
- Random resource for generating unique names

---

# Terraform Block

```hcl
terraform {

  required_version = ">=1.15"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-storage-rg"
    storage_account_name = "<storage account name>"
    container_name       = "<container name>"
    key                  = "dev.terraform.tfstate"
  }
}
```

---

# Terraform Version

```hcl
required_version = ">=1.15"
```

Specifies the minimum Terraform version required to run this configuration.

**Meaning**

- Terraform version **1.15 or later** is required.
- Older versions will fail during initialization.

---

# Required Providers

Terraform downloads the required providers automatically during `terraform init`.

## AzureRM Provider

```hcl
azurerm = {
  source  = "hashicorp/azurerm"
  version = "~>4.0"
}
```

### Purpose

Used to create and manage Azure infrastructure.

Examples:

- Resource Groups
- Virtual Networks
- AKS Clusters
- Storage Accounts
- Virtual Machines
- Key Vaults

---

## AzureAD Provider

```hcl
azuread = {
  source  = "hashicorp/azuread"
  version = "~>3.0"
}
```

### Purpose

Used to manage Microsoft Entra ID (formerly Azure Active Directory).

Examples:

- Users
- Groups
- Applications
- Service Principals
- Role Assignments

---

## Random Provider

```hcl
random = {
  source  = "hashicorp/random"
  version = "~>3.0"
}
```

### Purpose

Generates random values to create unique resource names.

Examples:

- Random strings
- Random IDs
- Random passwords
- Random pet names

---

# Backend Configuration

Terraform stores its state remotely in an Azure Storage Account.

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-storage-rg"
  storage_account_name = "<storage account name>"
  container_name       = "<container name>"
  key                  = "dev.terraform.tfstate"
}
```

## Backend Parameters

| Parameter | Description |
|-----------|-------------|
| `resource_group_name` | Resource group containing the storage account |
| `storage_account_name` | Azure Storage Account used for Terraform state |
| `container_name` | Blob container that stores the state file |
| `key` | Name of the Terraform state file |

---

## Why Use a Remote Backend?

Using Azure Storage as the backend provides several benefits:

- Centralized state management
- State locking (prevents concurrent updates)
- Version history
- Team collaboration
- Improved security
- Reliable state storage

---

# AzureRM Provider Configuration

```hcl
provider "azurerm" {
  subscription_id = "<subscription id>"

  features {

  }
}
```

## Parameters

| Parameter | Description |
|-----------|-------------|
| `subscription_id` | Azure Subscription ID where resources will be deployed |
| `features {}` | Enables AzureRM provider features (required block, even if empty) |

---

# Random Resource

```hcl
resource "random_pet" "aksrandom" {

}
```

## Purpose

Creates a random, human-readable name.

Example outputs:

```text
happy-lion
```

```text
gentle-fox
```

```text
bright-panda
```

This value is commonly appended to Azure resource names to ensure global uniqueness.

Example:

```hcl
resource_group_name = "aks-${random_pet.aksrandom.id}"
```

Possible output:

```text
aks-happy-lion
```

---

# Initialization

Initialize the Terraform working directory.

```bash
terraform init
```

Terraform will:

- Download required providers
- Configure the Azure backend
- Initialize the working directory

---

# Validate Configuration

Validate the Terraform configuration.

```bash
terraform validate
```

---

# Format Configuration

Automatically format Terraform files.

```bash
terraform fmt
```

---

# Generate Execution Plan

Preview the changes Terraform will make.

```bash
terraform plan
```

---

# Apply the Configuration

Create or update Azure resources.

```bash
terraform apply
```

---

# Destroy Resources

Delete all resources managed by Terraform.

```bash
terraform destroy
```

