# Azure Kubernetes Service (AKS) Deployment using Terraform

Deploy a production-ready Azure Kubernetes Service (AKS) cluster using Terraform with Azure Resource Manager (AzureRM), Microsoft Entra ID (Azure AD), and Azure Monitor.

---

## Features

- Deploy Azure Kubernetes Service (AKS)
- Azure Resource Group provisioning
- Azure Log Analytics Workspace
- Microsoft Entra ID (Azure AD) integration
- Azure Monitor (OMS Agent)
- System-assigned Managed Identity
- Linux and Windows node pools
- Auto Scaling enabled
- Multi-Availability Zone deployment
- Remote Terraform State in Azure Storage

---

## Architecture

```text
                     Azure Subscription
                              │
                     Resource Group
                              │
          ┌───────────────────┴───────────────────┐
          │                                       │
 Log Analytics Workspace                  AKS Cluster
                                                  │
                ┌─────────────────────────────────┴────────────────────────┐
                │                                                          │
         System Node Pool                                         User Node Pools
                │                                            ┌─────────────┴──────────────┐
                │                                            │                            │
          Linux Nodes                                   Linux Pool                 Windows Pool
```

---

## Prerequisites

Before deploying, ensure you have:

- Ubuntu 22.04 or later
- Azure Subscription
- Azure CLI
- Terraform v1.5+
- SSH Key Pair
- Azure Storage Account (for Terraform backend)

---

## Install Terraform

Follow the official HashiCorp installation guide:

https://developer.hashicorp.com/terraform/install

or see:

- [docs/installation.md](docs/installation.md)

---

## Install Azure CLI

```bash
curl -fsSL 'https://azurecliprod.blob.core.windows.net/$root/deb_install.sh' | sudo bash
```

Verify:

```bash
az version
```

---

## Authenticate with Azure

```bash
az login
```

Verify the active subscription:

```bash
az account show
```

If required:

```bash
az account set --subscription "<subscription-id>"
```

---

## Project Structure

```text
terraform-aks/
│
├── resource_group.tf
├── aks_version_datasource.tf
├── aks-administrator-group.tf
├── log-analytics-workspace.tf
├── aks-cluster.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── aks-cluster-windows-nodepools.tf
├── aks-cluster-linux-nodepools.tf
├── terraform.tfvars
├── README.md
└── docs/
```

---

## Terraform Workflow

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Format Terraform files:

```bash
terraform fmt
```

Generate execution plan:

```bash
terraform plan
```

Deploy infrastructure:

```bash
terraform apply
```

Destroy resources:

```bash
terraform destroy
```

---

## Resources Created

The deployment provisions:

- Azure Resource Group
- Azure Kubernetes Service (AKS)
- Azure Log Analytics Workspace
- Microsoft Entra ID Administrator Group
- System Node Pool
- Linux User Node Pool
- Windows User Node Pool
- Azure Monitor Integration

---

## Node Pools

### System Node Pool

| Property | Value |
|----------|-------|
| Mode | System |
| OS | Linux |
| VM Size | Standard_D2_v2 |
| Autoscaling | Enabled |

### Linux User Pool

| Property | Value |
|----------|-------|
| Mode | User |
| OS | Linux |
| Workload | Java Applications |

### Windows User Pool

| Property | Value |
|----------|-------|
| Mode | User |
| OS | Windows |
| Workload | .NET Applications |

---

## Outputs

After deployment Terraform displays:

- Resource Group Name
- Resource Group ID
- AKS Cluster Name
- AKS Cluster ID
- Kubernetes Version
- Azure AD Group ID

View outputs anytime:

```bash
terraform output
```

---

## Best Practices

- Store Terraform state remotely.
- Never commit secrets to Git.
- Use Azure Key Vault for sensitive values.
- Enable autoscaling.
- Use separate node pools for workloads.
- Use Microsoft Entra ID RBAC.
- Organize Terraform files by purpose.
- Apply consistent tags to Azure resources.

---

## Documentation

| Guide | Description |
|--------|-------------|
| installation.md | Install Terraform and Azure CLI |
| terraform.md | Terraform configuration explained |
| aks-deployment.md | AKS resources and architecture |
| troubleshooting.md | Common installation and deployment issues |

---

## References

- Terraform Documentation  
  https://developer.hashicorp.com/terraform

- AzureRM Provider  
  https://registry.terraform.io/providers/hashicorp/azurerm/latest

- Azure AD Provider  
  https://registry.terraform.io/providers/hashicorp/azuread/latest

- Azure Kubernetes Service Documentation  
  https://learn.microsoft.com/azure/aks/

- Azure CLI Documentation  
  https://learn.microsoft.com/cli/azure/

---

## License

This project is licensed under the MIT License.