## RUN AS FOLLOWS
1: 

```
ansible-playbook -i ansible/inventory/kube_inventory  ansible/playbook/proxy-server-prep.yaml
```
2:
```
 ansible-playbook -i ansible/inventory/kube_inventory  ansible/playbook/kube_dependencies.yml
 ```
 3:
 ```
 ansible-playbook -i ansible/inventory/kube_inventory  ansible/playbook/kube_master.yml
 ```
 4:
 ```
 ansible-playbook -i ansible/inventory/kube_inventory  ansible/playbook/kube_workers.yml
 ```
 5:
 ```
 ansible-playbook -i ansible/inventory/kube_inventory  ansible/playbook/create_namespace.yml
 ```
 6:
 ```
 ansible-playbook -i ansible/inventory/kube_inventory  ansible/playbook/create_and_expose_nginx.yml 
 ```
 7:
 ```
 ansible-playbook -i ansible/inventory/kube_inventory  ansible/playbook/deploy_k8s_dashboard.yml
 ```