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

