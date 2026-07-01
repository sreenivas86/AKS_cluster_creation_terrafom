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