# Generate SSH Key Pair for Terraform AKS Deployment

Create a directory to store the SSH keys:

```bash
mkdir -p ~/.ssh/terraform/sshkeys
```

Generate an RSA 4096-bit SSH key pair:

```bash
ssh-keygen -t ed25519 \
  -f ~/.ssh/terraform/sshkeys/terraform-aks.pem \
  -C "terraform-aks" \
  -N ""
```

This command creates:

- **Private Key:** `~/.ssh/terraform/sshkeys/terraform-aks.pem`
- **Public Key:** `~/.ssh/terraform/sshkeys/terraform-aks.pem.pub`

Rename the public key (optional):

```bash
mv ~/.ssh/terraform/sshkeys/terraform-aks.pem.pub \
   ~/.ssh/terraform/sshkeys/terraform-aks.pub
```

Set secure permissions:

```bash
chmod 400 ~/.ssh/terraform/sshkeys/terraform-aks.pem
chmod 644 ~/.ssh/terraform/sshkeys/terraform-aks.pub
```

Verify the generated keys:

```bash
ls -l ~/.ssh/terraform/sshkeys
```

Example output:

```text
-r-------- 1 user user 3381 terraform-aks.pem
-rw-r--r-- 1 user user  743 terraform-aks.pub
```

## Use the Public Key in Terraform

Update your Terraform variable:

```hcl
variable "ssh_public_key" {
  description = "SSH public key for AKS Linux nodes"
  default     = "~/.ssh/terraform/sshkeys/terraform-aks.pub"
}
```

Reference it in the AKS cluster configuration:

```hcl
linux_profile {
  admin_username = "ubuntu"

  ssh_key {
    key_data = file(var.ssh_public_key)
  }
}
```