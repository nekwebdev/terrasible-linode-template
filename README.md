# Infrastructure as Code Template

This repository contains the Infrastructure as Code (IaC) template for deploying multiple Linode VPS using Terraform and Ansible. The infrastructure provides an automated, secure, and scalable deployment with Linode VPC networking, firewall, object storage and Cloudflare DNS integration.

## 🏗️ Terraform Infrastructure

The Terraform code in this repository deploys:

- Linode virtual machines running Debian/Alpine Linux
- VPC for secure private network communication
- Linode firewall
- Linode object storage for terraform state
- Cloudflare DNS integration

## 🤖 Ansible Roles

The Ansible code in this repository configures:

- Packages upgrade and auto-updates
- Hostname and hosts settings
- OS hardening
- SSH hardening

## 🐳 Local Development Environment

This project uses Terraform and Ansible Docker containers for local development to ensure consistent environments across team members.

Build the custom `ansible-runner` container:

```bash
cd ansible
docker build -t ansible-runner .
```

Load the provided aliases for easy access to Terraform and Ansible commands:

```bash
source aliases
```

Or add them to your shell configuration file (`~/.bashrc` or `~/.zshrc`).

The aliases provide:

- `terraform` - Runs Terraform commands in a containerized environment
- `ansible-playbook` - Runs Ansible playbooks in a containerized environment
- `ansible` - Runs Ansible commands in a containerized environment
- `ansible-lint` - Runs Ansible linting in a containerized environment

## 🛠️ Configuration

### Terraform variables

1. Copy `template.terraform.tfvars` to `terraform.tfvars`:

```bash
cp template.terraform.tfvars terraform.tfvars
```

2. Edit the `terraform.tfvars` file with your specific values:
   - Linode API token
   - Cloudflare API token and Zone ID
   - Domain name
   - SSH public keys
   - Optional configurations

### Object Storage for Terraform state variables

1. Copy `object_storage/template.terraform.tfvars` to `object_storage/terraform.tfvars`:

```bash
cp object_storage/template.terraform.tfvars object_storage/terraform.tfvars
```

2. Edit the `object_storage/terraform.tfvars` file with the same values used in `terraform.tfvars`

### Create Linode Object Storage for Terraform state

With the `object_storage/terraform.tfvars` file configured run the script:

```bash
./create_object_storage.sh
```

The script will run terraform from docker applying `object_storage/main.tf`.

Terraform will:
   - create the object storage on linode with access keys to save the main terraform state.
   - create `object_storage/credentials` with the access keys to be used for the main terraform state.

### Initialize Terraform backend

Sadly terraform does not accept variables in it's backend configuration, so we will use the CLI options to pass the required variabled.

This is an example command, adjust ***ONLY*** `server` and keep the `-tfstate` so it matches the bucket we just created. Match the region as well but note the added `-1`.

```bash
terraform init -backend-config="bucket=server-tfstate" -backend-config="region=us-lax-1" -backend-config="endpoint=https://us-lax-1.linodeobjects.com"
```

## 🚀 Creating the Infrastructure

1. **Apply the Terraform configuration:**
   ```bash
   terraform apply
   ```

2. **Configure the servers with Ansible:**
   ```bash
   cd ansible
   ansible-playbook site.yaml
   ```

## 📝 License

This project is licensed under the GPL v3 License - see the LICENSE file for details.
