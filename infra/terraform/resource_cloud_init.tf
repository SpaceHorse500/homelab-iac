resource "proxmox_virtual_environment_file" "cloud_user_config" {
  content_type = "snippets"
  datastore_id = "local"              # not local-lvm
  node_name    = var.target_node
  overwrite    = true

  source_raw {
    file_name = "${var.vm_hostname}.${var.domain}-ci-user.yml"
    data      = local.user_data_yaml
  }
}

resource "proxmox_virtual_environment_file" "cloud_meta_config" {
  content_type = "snippets"
  datastore_id = "local"              # not local-lvm
  node_name    = var.target_node
  overwrite    = true

  source_raw {
    file_name = "${var.vm_hostname}.${var.domain}-ci-meta_data.yml"
    data      = local.meta_data_yaml
  }
}
