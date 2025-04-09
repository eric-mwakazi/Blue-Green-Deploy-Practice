
// Variable definitions
variable "pm_api_url" {
  description = "The proxmox url"
  type        = string
}

variable "pm_api_token_secret" {
  description = "The cloud-init user for the VM"
  type        = string
}

variable "pm_api_token_id" {
  description = "The cloud-init user for the VM"
  type        = string
}

variable "ciuser" {
  description = "The cloud-init user for the VM"
  type        = string
  default     = "eric"
}

variable "ssh_keys" {
  description = "List of SSH public keys to authorize"
  type        = list(string)
}

variable "START_VMID" {
  description = "Unique VM ID"
  default = 799
}
# variable "cipassword" {
#   description = "Password for the VM user"
#   type        = string
#   sensitive   = true
# }


variable "master_count" {
  default = 1
}

# variable "bastion_count" {
#   default = 1
# }

variable "worker_count" {
  default = 2
}

variable "proxy_count" {
  default = 1
}

variable "devops_vm" {
  default = 1
}
