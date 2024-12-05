Calculate the Next Version
Download k8s components binaries for installation
Start to pull images on the necessary nodes
Synchronize kubernetes binaries
Upgrade cluster on master nodes
Get kubernetes cluster status
upgrade the worker nodes

- [ ] kubectl drain node <node-to-drain>
- [ ] apt-cache madison kubeadm | awk '{ print $3 }'
- [ ] apt-mark unhold kubeadm && apt-get update && apt-get install -y kubeadm='1.26.5-1.1' && apt-mark hold kubeadm
- [ ] kubeadm upgrade plan -- not for the worker
- [ ] kubeadm upgrade apply v1.26.5 --certificate-renewal=false
- [ ] for other master nodes: kubeadm upgrade node --certificate-renewal=false
- [ ] kubectl drain <node-to-drain> --ignore-daemonsets -- recommended draining point
- [ ] apt-mark unhold kubelet kubectl && \
  apt-get update && apt-get install -y kubelet='1.26.5-1.1' kubectl='1.26.5-1.1' && \
  apt-mark hold kubelet kubectl
- [ ] systemctl daemon-reload
- [ ] systemctl restart kubelet
- [ ] kubectl uncordon <node-to-drain>

  //for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
  //# Add Docker's official GPG key:
  //sudo apt-get update
  //sudo apt-get install ca-certificates curl
  //sudo install -m 0755 -d /etc/apt/keyrings
  //sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  //sudo chmod a+r /etc/apt/keyrings/docker.asc
  //
  //# Add the repository to Apt sources:
  //echo \
  //  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  //  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  //  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  //sudo apt-get update
  //sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin

  //curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.26/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  //sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
  //echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.26/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  //sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
  //apt update -y --allow-insecure-repositories
  //apt install -y kubectl=1.26.0-2.1 kubelet=1.26.0-2.1 kubeadm=1.26.0-2.1 --allow-unauthenticated
  //init --upload-certs --skip-phases=addon/kube-proxy
  //join --apiserver-advertise-address=<master-node-ip>

  //kubectl create secret generic -n kube-system cilium-etcd-secrets \
  //--from-file=etcd-client-ca.crt=/etc/kubernetes/pki/etcd-ca.pem \
  //--from-file=etcd-client.key=/etc/kubernetes/pki/etcd.key \
  //--from-file=etcd-client.crt=/etc/kubernetes/pki/etcd.cert

  // experiment with https://docs.cilium.io/en/stable/operations/performance/tuning/ given Supported NICs for BIG TCP: mlx4, mlx5, ice exists
  //// check if --allocate-node-cidrs true in kube-controller-manager
  //API_SERVER_IP=10.0.0.7
  //helm template cilium/cilium --version 1.14.0 --namespace kube-system \
  //--set etcd.enabled=true --set etcd.ssl=true \
  //--set "etcd.endpoints[0]=https://10.0.0.7:2379" \
  //--set "etcd.endpoints[1]=https://10.0.0.9:2379" \
  //--set "etcd.endpoints[2]=https://10.0.0.10:2379" \
  //--set identityAllocationMode=kvstore \
  //--set kubeProxyReplacement=true \
  //--set bpf.hostLegacyRouting=false \
  //--set tunnelProtocol=geneve \
  //--set enable-ipv4-masquerade=true \
  //--set bpf.masquerade=true \
  //--set enable-ipv4=true \
  //--set enable-ipv6=false \
  //--set clean-cilium-bpf-state=true \
  //--set preallocate-bpf-maps=true \
  //--set cni.install=true \
  //--set cni.exclusive=true \
  //--set ipv4NativeRoutingCIDR=10.244.0.0/16 \
  //--set ipam.operator.clusterPoolIPv4PodCIDRList=10.244.0.0/16 \
  //--set ipam.mode=cluster-pool \
  //--set monitor-aggregation=true \
  //--set bpf.disableExternalIPMitigation=true \
  //--set loadBalancer.algorithm=maglev \
  //--set k8sServiceHost=${API_SERVER_IP} \
  //--set k8sServicePort=6443 \
  //--set externalTrafficPolicy=Local \
  //--set hubble.relay.enabled=true \
  //--set hubble.ui.enabled=true \
  //--output-dir manifests

  ///////--set endpointRoutes.enabled=true \
  //--set routingMode=native \
  //--set loadBalancer.dsrDispatch=geneve \
  //--set loadBalancer.mode=dsr \ // doesn't work with geneve tunneling

  // validation: kubectl -n kube-system exec ds/cilium -- cilium-dbg status | grep KubeProxyReplacement
  // status: kubectl -n kube-system exec ds/cilium -- cilium-dbg status --verbose
  // status: kubectl -n kube-system exec ds/cilium -- cilium-dbg --all-addresses


kubeadm join 10.0.16.5:6443 --token 8eocea.hrd9rkawe3huv5qa --discovery-token-ca-cert-hash sha256:b3bcac9f8aa88324fac0d0fb79c7bb2a7938326f00baacca3e0de108c432a6db --control-plane --apiserver-advertise-address 10.0.16.6
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

kubectl create -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
might be   - --kubelet-insecure-tls in the deployment metrics-server

kubectl create -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/cloud/baremetal/deploy.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml

apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
name: staging-pool
namespace: metallb-system
spec:
addresses:
- 20.244.81.47/32