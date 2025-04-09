// Define Terraform provider configuration.
// Use the Telmate/proxmox plugin version 3.0.1-rc6.
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

// pm_api_url → Points to Proxmox API endpoint (https://<Proxmox-IP>:8006/api2/json).
// pm_api_token_id → Uses the root user (root@pam) and the token name "terraform".
// pm_api_token_secret → The actual API token secret for authentication.
// pm_tls_insecure = true → Disables SSL verification (Not recommended for production).


provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = var.pm_api_url
    pm_api_token_secret = var.pm_api_token_secret
    pm_api_token_id = var.pm_api_token_id

// Logging configuration.
// pm_log_file → Logs Terraform-Proxmox API interactions to "terraform-plugin-proxmox.log".
// pm_log_levels:
// _default = "debug" → Enables debug-level logging.
// _capturelog = "" → Disables capturing logs separately.

    pm_log_file   = "terraform-plugin-proxmox.log"
    pm_log_levels = {
      _default    = "debug"
      _capturelog = ""
    }
}

