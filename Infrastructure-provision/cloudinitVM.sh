#!/bin/bash

# Configuration Variables
CONFIG_FILE="/etc/pve/storage.cfg"
STORAGE_NAME="dir: local"
SNIPPETS_PATH="/var/lib/vz/snippets"
SNIPPET_FILE="$SNIPPETS_PATH/vendor.yaml"
VM_ID="8002"
VM_NAME="ubuntu-2404-cloudinit-template"
STORAGE_POOL="local-lvm"
CLOUD_IMAGE="/var/lib/vz/template/iso/jammy-server-cloudimg-amd64.img"
CI_USER="eric"
CI_PASSWORD="1234"  # Change this or fetch securely
#CI_PASSWORD="${CI_PASSWORD:-$(read -sp 'Enter CI password: ' password && echo $password)}"  # Fetch securely from environment variable or prompt
SSH_KEYS="$HOME/.ssh/authorized_keys"

# Ensure snippets storage is enabled in storage.cfg
if grep -A3 "$STORAGE_NAME" "$CONFIG_FILE" | grep -q "content .*snippets"; then
    echo "Snippets is already enabled in storage.cfg. No changes needed."
else
    echo "Enabling snippets for local storage..."
    sed -i "/$STORAGE_NAME/,/content/ s/\(content .*iso.*\)/\1,snippets/" "$CONFIG_FILE"

    echo "Restarting pveproxy..."
    systemctl restart pvedaemon pveproxy
fi

## /var/lib/vz/snippets/vendor.yaml
# Ensure snippets directory exists
mkdir -p "$SNIPPETS_PATH"

# Create cloud-init snippet
cat << EOF | tee "$SNIPPET_FILE"
#cloud-config
bootcmd:
    - apt update
    - apt install -y qemu-guest-agent curl nano net-tools
    - systemctl start qemu-guest-agent
    

runcmd:
    - echo network: {config: disabled} > /etc/cloud/cloud.cfg.d/custom-network-rule.cfg
    - echo 10.176.16.79  k8s-asnible  >> /etc/hosts
    - echo 10.176.16.80  k8s-master-01 >> /etc/hosts
    - echo 10.176.16.81  k8s-master-02 >> /etc/hosts
    - echo 10.176.16.82  k8s-worker-01 >> /etc/hosts
    - echo 10.176.16.83  k8s-worker-02 >> /etc/hosts
    - echo 10.176.16.84  k8s-worker-03 >> /etc/hosts
    - echo 10.176.16.85  k8s-worker-04 >> /etc/hosts
    - echo 10.176.16.86  k8s-worker-05 >> /etc/hosts
    - echo 10.176.16.87  k8s-worker-06 >> /etc/hosts
    - echo 10.176.16.88  k8s-proxy-01 >> /etc/hosts
    - echo 10.176.16.89  k8s-proxy-02 >> /etc/hosts
    - echo nameserver 10.176.16.24 > /etc/resolv.conf
    - echo nameserver 8.8.8.8 >> /etc/resolv.conf
    - echo nameserver 1.1.1.1 >> /etc/resolv.conf 

groups:
  - admingroup: [root,sys]
  - cloud-users

users:
    - default
    - name: kirui
      gecos: Kirui
      primary_group: kirui
      groups: admingroup
      passwd: 59e24528a2e3e65a173b4cf6fb8e0495d31cd097064e667a3ccb5cf39df09d885d8e49df4357e62a8e86a3444abaf13bf8bbe25e1b162162b0de68fed3bd7646
      lock_passwd: false
      inactive: 21
      expiredate: '2032-09-01'
EOF

qemu-img resize $CLOUD_IMAGE 12G

qm create $VM_ID --name "$VM_NAME" --ostype l26 \
    --memory 1024 \
    --agent 1 \
    --bios ovmf --machine q35 --efidisk0 $STORAGE_POOL:0,pre-enrolled-keys=0 \
    --cpu host --socket 1 --cores 1 \
    --vga serial0 --serial0 socket  \
    --net0 virtio,bridge=vmbr0

qm importdisk $VM_ID $CLOUD_IMAGE $STORAGE_POOL
qm set $VM_ID --scsihw virtio-scsi-pci --virtio0 $STORAGE_POOL:vm-$VM_ID-disk-1,discard=on
qm set $VM_ID --boot order=virtio0
qm set $VM_ID --scsi1 $STORAGE_POOL:cloudinit

# Configure Cloud-Init settings
qm set "$VM_ID" --cicustom "vendor=local:snippets/vendor.yaml"
qm set "$VM_ID" --tags "ubuntu-template,24.04,cloudinit"
qm set "$VM_ID" --ciuser "$CI_USER"
qm set "$VM_ID" --cipassword "$(openssl passwd -6 "$CI_PASSWORD")"
qm set "$VM_ID" --sshkeys "$SSH_KEYS"
qm set "$VM_ID" --ipconfig0 ip=dhcp
qm start $VM_ID
sleep 180 ## To allow the VM to boot and run cloud-init, install updates, etc.
qm stop $VM_ID
qm set "$VM_ID" --delete scsi1
qm set "$VM_ID" --bios seabios
qm start $VM_ID
