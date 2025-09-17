# Homelab IaC

## Overview
This repository provides **Infrastructure as Code (IaC)** for automating a Proxmox-based homelab environment.  
It uses a layered approach combining:
- **Terraform** – to provision and manage virtual machines on Proxmox
- **Cloud-init** – to bootstrap and configure VM templates automatically
- **Ansible** – to handle post-provisioning configuration with role-based automation

The goal is to make VM provisioning reproducible, modular, and scalable, reducing manual setup time and ensuring consistency across environments.

---

## Features
- Provision VMs in **Proxmox** using Terraform modules.
- Use **cloud-init Ubuntu templates** for automatic OS configuration.
- Apply **role-based Ansible playbooks** for services and applications.
- Maintain homelab environments declaratively and idempotently.
- Modular design: infrastructure (Terraform), bootstrapping (cloud-init), configuration (Ansible).

---

## Repository Structure
```
homelab-iac/
│
├── terraform/        # Terraform configuration for VM provisioning
├── ansible/          # Ansible roles and playbooks for automation
├── cloud-init/       # Cloud-init templates for VM bootstrapping
└── README.md         # Project documentation
```

---

## Prerequisites
Before using this project, ensure you have:
- A running **Proxmox VE** environment
- Installed tools on your local machine:
  - [Terraform](https://www.terraform.io/)
  - [Ansible](https://www.ansible.com/)
  - SSH access to Proxmox
- An Ubuntu cloud-init template uploaded to Proxmox

---

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/SpaceHorse500/homelab-iac.git
cd homelab-iac
```

### 2. Configure Terraform
Update the variables in `terraform/variables.tf` or create a `terraform.tfvars` file with your environment details (Proxmox credentials, storage, network).

### 3. Apply Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

This will create and provision virtual machines in Proxmox.

### 4. Configure with Ansible
Once VMs are provisioned and reachable via SSH, run Ansible playbooks:

```bash
cd ansible
ansible-playbook -i inventory site.yml
```

This applies roles for services, packages, and configuration.

---

## Roadmap / To Do
- [ ] Add CI pipeline for linting Terraform & Ansible configs
- [ ] Expand role library (e.g., Docker, Kubernetes, monitoring tools)
- [ ] Provide example inventories for common setups
- [ ] Document secret management with Ansible Vault

---

## Author
Developed and maintained by **SpaceHorse500**  