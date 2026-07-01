# terraform_aks_cluster
create AKS cluster using terraform manifest 
# Install Terraform on Ubuntu

**Reference:** https://developer.hashicorp.com/terraform/install

## Step 1: Download the HashiCorp GPG key and save it to `/usr/share/keyrings`

```bash
wget -O- https://apt.releases.hashicorp.com/gpg \
| sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

---

## Step 2: Add the HashiCorp repository to the APT sources list

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list
```

---

## Step 3: Install Terraform

```bash
sudo apt update
sudo apt install -y terraform
```

---

## Step 4: Verify the installation

```bash
terraform -v
```

Expected output:

```text
Terraform v1.x.x
```

---

# Troubleshooting

## Error 1: `gpg: command not found`

### Error

```text
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

sudo: 'gpg': command not found
```

### Cause

The **GPG** package is not installed on the system.

### Verify

```bash
gpg --version
```

If you receive:

```text
gpg: command not found
```

install the package:

```bash
sudo apt update
sudo apt install -y gnupg2
```

Then rerun Step 1.

---

# Install Azure CLI on Ubuntu

Install Azure CLI using the official Microsoft installation script:

```bash
curl -fsSL https://azurecliprod.blob.core.windows.net/\$root/deb_install.sh | sudo bash
```

---

## Verify the installation

```bash
az version
```

or

```bash
az --version
```

Expected output:

```text
azure-cli                         x.x.x
```


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

---


# Azure Kubernetes Service (AKS) Deployment using Terraform

This document explains the Terraform configuration used to provision an Azure Kubernetes Service (AKS) cluster along with supporting Azure resources.

---

# Architecture Overview

The Terraform configuration provisions the following resources:

- Azure Resource Group
- Azure Active Directory (Microsoft Entra ID) Administrator Group
- Azure Log Analytics Workspace
- Azure Kubernetes Service (AKS) Cluster
- Linux System Node Pool
- Linux User Node Pool
- Windows User Node Pool
- Remote Terraform State (Azure Storage Backend)
- Outputs for AKS and Resource Group information

---

# Prerequisites

Before deploying the infrastructure, ensure the following prerequisites are met:

- Terraform v1.15 or later
- Azure CLI installed
- Logged in to Azure

```bash
az login
```

- An Azure subscription
- Existing Azure Storage Account for Terraform backend
- SSH Public Key available

Example:

```text
~/.ssh/aksprodsshkey.pub
```

---

# Input Variables

The deployment uses the following input variables.

## Azure Location

```hcl
variable "location" {
  default = "Central US"
}
```

Specifies the Azure region where resources will be deployed.

Default:

```text
Central US
```

---

## Resource Group Name

```hcl
variable "resource_group_name" {
  default = "terraform-aks"
}
```

Used to create the Azure Resource Group.

Example Resource Group:

```text
terraform-aks-dev
```

---

## Environment

```hcl
variable "environment" {
  default = "dev"
}
```

Identifies the deployment environment.

Examples:

- dev
- test
- stage
- prod

---

## SSH Public Key

```hcl
variable "ssh_publi_key" {
  default = "~/.ssh/aksprodsshkey.pub"
}
```

Used to authenticate Linux worker nodes.

---

## Windows Administrator Username

```hcl
variable "windows_admin_username" {
  default = "azureuser"
}
```

Administrator account for Windows worker nodes.

---

## Windows Administrator Password

```hcl
variable "windows_admin_password" {
  default = "Sreenu@1234"
}
```

Administrator password for Windows worker nodes.

> **Security Note:** Do not hardcode passwords in Terraform code. Store sensitive values in `terraform.tfvars`, environment variables, or Azure Key Vault.

---

# Resource Group

```hcl
resource "azurerm_resource_group" "aks_rg"
```

Creates the Resource Group.

Generated name:

```text
terraform-aks-dev
```

Location:

```text
Central US
```

---

# Azure AD Administrator Group

```hcl
resource "azuread_group" "aks_administtrator"
```

Creates an Azure AD (Microsoft Entra ID) security group that will have administrator access to the AKS cluster.

Example name:

```text
terraform-aks-dev-cluster-administrators
```

Purpose:

- Cluster administration
- RBAC management
- Azure AD integration

---

# Kubernetes Version Data Source

```hcl
data "azurerm_kubernetes_service_versions" "current"
```

Retrieves the latest supported AKS Kubernetes versions available in the selected Azure region.

Used for:

- AKS Cluster version
- Node Pool version

---

# Log Analytics Workspace

```hcl
resource "azurerm_log_analytics_workspace" "insights"
```

Creates an Azure Log Analytics Workspace.

Purpose:

- Container Insights
- AKS monitoring
- Log collection
- Metrics
- Diagnostics

Retention:

```text
30 Days
```

Example workspace name:

```text
logs-happy-lion
```

---

# Azure Kubernetes Service (AKS)

```hcl
resource "azurerm_kubernetes_cluster" "aks_cluster"
```

Creates the AKS cluster.

## Configuration Summary

| Property | Value |
|-----------|-------|
| Kubernetes Version | Latest supported version |
| DNS Prefix | `<resource-group>-cluster` |
| Identity | System Assigned |
| Network Plugin | Azure CNI |
| Load Balancer | Standard |
| Node Resource Group | Auto-created |
| Monitoring | Azure Monitor |
| Authentication | Azure AD |

---

# Default System Node Pool

The AKS cluster contains one default system node pool.

Configuration:

| Property | Value |
|-----------|-------|
| Name | `systempool` |
| Mode | System |
| VM Size | `Standard_D2_v2` |
| Auto Scaling | Enabled |
| Minimum Nodes | 1 |
| Maximum Nodes | 3 |
| Availability Zones | 1,2,3 |
| OS | Linux |
| Disk Size | 30 GB |

Labels:

```text
nodepool-type = system
environment   = dev
nodepoolos    = linux
app           = system-apps
```

---

# Identity

```hcl
identity {
    type = "SystemAssigned"
}
```

The cluster uses a System Assigned Managed Identity.

Benefits:

- No secrets to manage
- Secure authentication
- Azure-managed credentials

---

# Azure Monitor Integration

```hcl
oms_agent {
    log_analytics_workspace_id = ...
}
```

Enables:

- Container Insights
- Cluster metrics
- Node monitoring
- Pod monitoring

---

# Azure AD RBAC

```hcl
azure_active_directory_role_based_access_control
```

Enables Azure Active Directory authentication for AKS.

Administrator Group:

```text
terraform-aks-dev-cluster-administrators
```

---

# Linux Profile

```hcl
linux_profile
```

Configuration:

| Property | Value |
|-----------|-------|
| Username | ubuntu |
| Authentication | SSH Key |

---

# Windows Profile

```hcl
windows_profile
```

Configuration:

| Property | Value |
|-----------|-------|
| Username | azureuser |
| Password | Variable |

---

# Network Profile

```hcl
network_profile
```

Configuration:

| Property | Value |
|-----------|-------|
| Network Plugin | Azure |
| Load Balancer | Standard |

---

# User Node Pool (Linux)

```hcl
resource "azurerm_kubernetes_cluster_node_pool" "linux101"
```

Creates a Linux user node pool.

Configuration:

| Property | Value |
|-----------|-------|
| Name | linux101 |
| Mode | User |
| OS | Linux |
| VM Size | Standard_DS2_v2 |
| Auto Scaling | Enabled |
| Min Nodes | 1 |
| Max Nodes | 3 |
| Zones | 1,2,3 |

Labels:

```text
nodepool-type = user
environment   = dev
nodepoolos    = linux
app           = java-apps
```

Suitable for:

- Java applications
- Spring Boot
- Microservices
- Linux workloads

---

# User Node Pool (Windows)

```hcl
resource "azurerm_kubernetes_cluster_node_pool" "win101"
```

Creates a Windows user node pool.

Configuration:

| Property | Value |
|-----------|-------|
| Name | win101 |
| Mode | User |
| OS | Windows |
| VM Size | Standard_DS2_v2 |
| Disk | 60 GB |
| Auto Scaling | Enabled |
| Min Nodes | 1 |
| Max Nodes | 3 |

Labels:

```text
nodepool-type = user
environment   = dev
nodepoolos    = windows
app           = dotnet-apps
```

Suitable for:

- .NET Framework
- ASP.NET
- IIS Applications
- Windows Containers

---

# Outputs

The Terraform configuration exports the following values.

## Resource Group Outputs

| Output | Description |
|----------|-------------|
| `location` | Azure region |
| `resource_group_id` | Resource Group ID |
| `resource_group_name` | Resource Group Name |

---

## Kubernetes Version Outputs

| Output | Description |
|----------|-------------|
| `versions` | Supported AKS versions |
| `latest_version` | Latest AKS version |

---

## Azure AD Outputs

| Output | Description |
|----------|-------------|
| `azure_ad_group_id` | Azure AD Group ID |
| `azure_ad_group_objectid` | Azure AD Object ID |

---

## AKS Outputs

| Output | Description |
|----------|-------------|
| `aks_cluster_id` | AKS Cluster Resource ID |
| `aks_cluster_name` | AKS Cluster Name |
| `aks_cluster_kubernetes_version` | Kubernetes Version |

---

# Deployment Workflow

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Destroy all managed resources:

```bash
terraform destroy
```

---





# Summary

This Terraform configuration provisions a production-ready AKS environment that includes:

- Azure Resource Group
- Azure AD Administrator Group
- Log Analytics Workspace
- AKS Cluster with Azure CNI networking
- System Assigned Managed Identity
- Azure Monitor integration
- Azure AD RBAC
- Linux System Node Pool
- Linux User Node Pool
- Windows User Node Pool
- Autoscaling across Availability Zones
- Terraform outputs for key resource details
- Reusable, variable-driven infrastructure suitable for multiple environments such as Development, Testing, Staging, and Production.