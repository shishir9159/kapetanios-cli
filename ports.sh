https://rhui4-1.microsoft.com/pulp/repos/content/dist/layered/rhui/rhel8/x86_64/ansible/2/os
https://download.docker.com/linux/rhel/docker-ce.repo
https://pkgs.k8s.io/core:/stable:/v1.29/

# azure-cloud
address=/#/0.0.0.0
server=/rhui4-1.microsoft.com/168.63.129.16
server=/download.docker.com/168.63.129.16
server=/pkgs.k8s.io/168.63.129.16
server=/docker.io/168.63.129.16
server=/gcr.io/168.63.129.16
server=/github.com/168.63.129.16
server=/ghcr.io/168.63.129.16
server=/quay.io/168.63.129.16
server=/registry.k8s.io/168.63.129.16

firewall-cmd --zone=trusted --add-source=10.96.0.0/12 --permanent
firewall-cmd --zone=trusted --add-source=10.244.0.0/16 --permanent
firewall-cmd --zone=trusted --add-source=10.0.16.8/20 --permanent
sudo firewall-cmd --reload

sudo firewall-cmd --set-default-zone=drop
sudo firewall-cmd --add-service=ssh --permanent
firewall-cmd --permanent --add-icmp-block-inversion
firewall-cmd --permanent --add-icmp-block=echo-reply
firewall-cmd --permanent --add-icmp-block=echo-request
firewall-cmd --permanent --add-icmp-block=time-exceeded
firewall-cmd --permanent --add-icmp-block=port-unreachable
firewall-cmd --permanent --add-port={53/tcp,53/udp,80/tcp,179/tcp,443/tcp,6443/tcp,2379-2380/tcp,4240/tcp,4240/udp,10250-10259/tcp,8472/tcp,8472/udp,4244/tcp,4245/tcp,4250/tcp,4251/tcp,6081/udp,6060/tcp,6061/tcp,6062/tcp,9878/tcp,9879/tcp,9890/tcp,9891/tcp,9893/tcp,9901/tcp,9962/tcp,9963/tcp,9964/tcp,51871/udp,9500/tcp,9501/tcp,9502/tcp,9503/tcp,8500/tcp,8501/tcp,8502/tcp,8503/tcp,8504/tcp,8000/tcp,10000-30000/tcp,3260/tcp,8002/tcp,30001-31000/tcp,2049/tcp,15010/tcp,15012/tcp,15001/tcp,15000/tcp,15002/tcp,15006/tcp,9090/tcp,3000/tcp,5775/tcp,5778/tcp,20001/tcp,9411/tcp,15003/tcp,15004/tcp,15008/tcp,15020/tcp,15021/tcp,15053/tcp,15090/tcp,32768-60999/tcp} --permanent

firewall-cmd --zone=trusted --add-source=10.96.0.0/12 --permanent
firewall-cmd --zone=trusted --add-source=10.244.0.0/16 --permanent
firewall-cmd --reload