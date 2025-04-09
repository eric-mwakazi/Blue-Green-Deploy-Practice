// Define the Proxmox VM resource
resource "proxmox_vm_qemu" "proxy_node" {
  count = var.proxy_count

  // Dynamic naming based on node type
  name = "proxy-node-0${count.index + 1}"


  desc         = "Kubernetes Cluster Node"
  target_node  = "pve"
  pool         = "blue-green"
  tags         = "blue,green"
  clone        = "ubuntu-2404-cloudinit-template"
  agent        = 1
  os_type      = "cloud-init"
  sshkeys = join("\n", var.ssh_keys)

  // CPU & Memory
  cores       = 2
  sockets     = 2
  vcpus       = 0
  cpu_type    = "host"
  memory      = 2048

  // Boot & virtualization settings
  scsihw        = "virtio-scsi-pci"
  numa          = false
  boot          = "order=virtio0"
  hotplug       = "network,disk,usb"
  bootdisk      = "virtio0"
  balloon       = 1
  agent_timeout = 200
  vmid = var.START_VMID + 5
  onboot = true

  // Networking
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

    # Setup the ip address using cloud-init.
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=192.168.1.${88 + count.index}/24,gw=192.168.1.1"
  // Cloud-Init Disk
  disk {
    type     = "cloudinit"
    storage  = "local-lvm"
    backup   = false
    slot     = "scsi1"
  }

  // Primary Disk
  disk {
    type    = "disk"
    storage = "local-lvm"
    size    = "12G"
    backup  = true
    slot    = "virtio0"
  }

  // Serial Console
  serial {
    id   = 0
    type = "socket"
  }
}
