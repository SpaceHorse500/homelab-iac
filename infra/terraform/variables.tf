variable "api_token" {
  description = "Proxmox API token (PVEAPIToken=user@pam!tokenid=secret)"
  type        = string
  sensitive   = true
}

variable "pm_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
  default     = "https://192.168.1.96:8006/"
}

variable "pm_insecure" {
  description = "Skip TLS verification?"
  type        = bool
  default     = true
}

variable "target_node" {
  description = "Proxmox node"
  type        = string
  default     = "pve"
}

variable "template_vmid" {
  description = "Known template VMID to clone from (safe fallback)"
  type        = number
  default     = 9999
}

variable "template_tag" {
  description = "Extra tag on the template (in addition to 'template')"
  type        = string
  default     = "ubuntu24.04"
}

variable "vm_hostname" {
  description = "Short hostname (no domain)"
  type        = string
  default     = "machine"
}

variable "vm_gw_hostname" {
  description = "Short hostname (no domain)"
  type        = string
  default     = "u-gateway"
}

variable "domain" {
  description = "DNS domain"
  type        = string
  default     = "space.local"
}

variable "ssh_hypervisor_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOjxA+NHtSCKoM7hVUMTCa8cDWWxcYYuDQqNUEHvLy0"
}

variable "ssh_laptop_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILuS05kSIc1TSwmRyvX3g5KlvY/bY2whGlDGyj9iwrfd"
}

variable "onboot" {
  description = "Start VM on host boot"
  type        = bool
  default     = true
}

variable "vm_tags" {
  description = "Tags to set on created VM"
  type        = list(string)
  default     = ["managed-by-tf", "env-lab"]
}

variable "vm_gw_tags" {
  description = "Tags to set on created VM"
  type        = list(string)
  default     = ["managed-by-tf", "gateway","elk-stack"]
}


variable "cores" {
  type    = number
  default = 2
}

variable "sockets" {
  type    = number
  default = 1
}

variable "memory" {
  description = "RAM in MB"
  type        = number
  default     = 2048
}

variable "disk" {
  description = "Primary disk settings"
  type = object({
    storage = string
    size    = string # e.g., "10"
  })
  default = {
    storage = "local-lvm"
    size    = "10"
  }
}

variable "additionnal_disks" {
  description = "Extra disks map (index -> {storage,size})"
  type = map(object({
    storage = string
    size    = string
  }))
  default = {}
}