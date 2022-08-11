resource "proxmox_vm_qemu" "dev-microk8s-01" {
  name        = "dev-microk8s-01"
  target_node = "baymax"
  clone = "ubuntu-cloud-shared-baymax"
  #vmid = 0

  sockets = 4
  cores = 4
  memory = 16384

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.181/24"

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  #agent = 1

  disk {
    type         = "virtio"
    storage      = "baymax-fast"
    size         = "500G"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory/terraform.ini"
  content = split("/", substr(proxmox_vm_qemu.dev-microk8s-01.ipconfig0, 15, 18))[0]
}
