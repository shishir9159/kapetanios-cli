## Ansible
tested against
```Text
Linux 4.18.0-553.el8_10.x86_64
Red Hat Enterprise Linux release 8.10 (Ootpa)
```

```Bash
yum install -y ansible git
ansible-playbook -i inventory.ini install.yaml
ansible-playbook -i inventory.ini etcd.yaml
ansible-playbook -i inventory.ini create_master.yaml
ansible-playbook -i inventory.ini join_master.yaml
ansible-playbook -i inventory.ini join_worker.yaml
```
