data "proxmox_virtual_environment_vms" "template" {
  node_name = var.target_node
  tags      = ["template", var.template_tag]
}

locals {
  template_found_count = length(try(data.proxmox_virtual_environment_vms.template.vms, []))
  template_vm_id_safe  = try(one(data.proxmox_virtual_environment_vms.template.vms).vm_id, var.template_vmid)

  user_data_yaml = <<-EOT
    #cloud-config
    hostname: ${var.vm_hostname}
    local-hostname: ${var.vm_hostname}
    fqdn: ${var.vm_hostname}.${var.domain}
    manage_etc_hosts: true
    package_upgrade: true
    users:
      - default
      - name: user
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${var.ssh_hypervisor_public_key}
          - ${var.ssh_laptop_public_key}
    ssh_pwauth: true
  EOT

  meta_data_yaml = <<-EOT
    {
      "instance-id": "${sha1(var.vm_hostname)}",
      "local-hostname": "${var.vm_hostname}"
    }
  EOT
}
