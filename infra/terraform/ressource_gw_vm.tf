resource "proxmox_virtual_environment_vm" "gw_vm" {
  name      = "${var.vm_gw_hostname}.${var.domain}"
  node_name = var.target_node
  on_boot   = var.onboot

  agent {
    enabled = true
  }

  tags = var.vm_gw_tags

  cpu {
    type    = "x86-64-v2-AES"
    cores   = var.cores
    sockets = var.sockets
    flags   = []
  }

  memory {
    dedicated = var.memory
  }

  dynamic "network_device" {
    for_each = var.network_bridges
    content {
      bridge = network_device.value
      model  = "virtio"
    }
  }

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-single"

  disk {
    interface    = "scsi0"
    iothread     = true
    datastore_id = var.disk.storage
    size         = var.disk.size
    discard      = "ignore"
  }

  dynamic "disk" {
    for_each = var.additionnal_disks
    content {
      interface    = "scsi${1 + disk.key}"
      iothread     = true
      datastore_id = disk.value.storage
      size         = disk.value.size
      discard      = "ignore"
      file_format  = "raw"
    }
  }

  clone {
    vm_id        = local.template_vm_id_safe
    full         = true
    # datastore_id = var.disk.storage   # uncomment to force clone target storage
  }

  initialization {
    datastore_id = var.disk.storage
    interface    = "ide2"

    user_data_file_id = proxmox_virtual_environment_file.cloud_user_config.id
    meta_data_file_id = proxmox_virtual_environment_file.cloud_meta_config.id

    ip_config {
      ipv4 { address = "dhcp" }
    }
  }
}