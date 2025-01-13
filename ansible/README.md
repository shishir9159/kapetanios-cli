
```Bash
ansible-playbook -i inventory.ini install.yaml
ansible-playbook -i inventory.ini etcd.yaml
ansible-playbook -i inventory.ini create_master.yaml
ansible-playbook -i inventory.ini join_master.yaml
ansible-playbook -i inventory.ini join_worker.yaml
```
