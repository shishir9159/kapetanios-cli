## Ansible
tested against
```Text
Linux 4.18.0-553.el8_10.x86_64
Red Hat Enterprise Linux release 8.10 (Ootpa)

Red Hat Enterprise Linux release 9
```

```Bash
yum install -y ansible git
ansible-playbook -i inventory.ini install.yaml
ansible-playbook -i inventory.ini etcd.yaml
ansible-playbook -i inventory.ini create_master.yaml
ansible-playbook -i inventory.ini join_master.yaml
ansible-playbook -i inventory.ini join_worker.yaml
```

[//]: # (https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml)