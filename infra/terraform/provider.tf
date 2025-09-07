provider "proxmox" {
  endpoint  = var.pm_endpoint
  api_token = var.api_token
  insecure  = var.pm_insecure

  ssh {
    username    = "root"
    private_key = file("~/.ssh/id_ed25519")
      node {
        name    = "pve"
        address = "192.168.1.96"
      }
  }

}