output "template_search_count" {
  description = "How many VMs matched tags ['template', var.template_tag]?"
  value       = local.template_found_count
}

output "template_search_results" {
  description = "List of matched VMs (may be empty)"
  value       = try(data.proxmox_virtual_environment_vms.template.vms, [])
}

output "template_vmid_used" {
  description = "Template VMID actually used (falls back to var.template_vmid)"
  value       = local.template_vm_id_safe
}

output "snippet_user_file_id" {
  description = "Uploaded user-data snippet ID"
  value       = proxmox_virtual_environment_file.cloud_user_config.id
}

output "snippet_meta_file_id" {
  description = "Uploaded meta-data snippet ID"
  value       = proxmox_virtual_environment_file.cloud_meta_config.id
}

output "vm_summary" {
  description = "Created VM summary"
  value = {
    vm_id   = proxmox_virtual_environment_vm.vm.vm_id
    name    = proxmox_virtual_environment_vm.vm.name
    node    = proxmox_virtual_environment_vm.vm.node_name
    tags    = proxmox_virtual_environment_vm.vm.tags
    on_boot = proxmox_virtual_environment_vm.vm.on_boot
  }
}

output "vm_first_nic" {
  description = "First NIC (useful to confirm MAC / bridge)"
  value       = try(proxmox_virtual_environment_vm.vm.network_device[0], null)
}

output "cloud_init_debug" {
  description = "Where CI seed was created + which files were used"
  value = {
    ci_seed_datastore = var.disk.storage
    user_data_file    = proxmox_virtual_environment_file.cloud_user_config.source_raw[0].file_name
    meta_data_file    = proxmox_virtual_environment_file.cloud_meta_config.source_raw[0].file_name
  }
}