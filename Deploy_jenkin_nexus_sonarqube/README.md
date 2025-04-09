# Ansible playbook to automate the setup of your DevOps_VM inside Proxmox with:
## Installs: 
* ✅ Docker & Containerd
* ✅ Dockerized Nexus and SonarQube (restart on reboot)
* ✅ Native (non-Docker) installation of Jenkins

## 📂 File Structure (Recommended)
```
devops_setup/
├── playbook.yml
├── inventory.ini
```
## 🧾 inventory.ini

```ini
[devops_vm]
devops_vm_ip ansible_user=your_user ansible_ssh_private_key_file=~/.ssh/your_key ansible_sudo_pass=your_user_password
```
### Replace:

* devops_vm_ip with your VM IP (e.g., 192.168.1.20)
* your_user with your SSH user
* your_key with your SSH private key file path
* ansible_sudo_pass with actual remote user password

## ▶️ playbook.yml
Check it out: [deploy_jenkin_nexus_sonarqube.yml](deploy_jenkin_nexus_sonarqube.yml)

## 🚀 To Run the Playbook
```bash
ansible-playbook -i inventory.ini deploy_jenkin_nexus_sonarqube.yml
```
## ✅ What You Get
Docker running with containerd:
* Nexus at http://DevOps_VM_IP:8081
* SonarQube at http://DevOps_VM_IP:9000
* Jenkins running natively at http://DevOps_VM_IP:8080

