  kubectl create secret generic -n kube-system cilium-etcd-secrets \
  --from-file=etcd-client-ca.crt=/etc/kubernetes/pki/etcd-ca.pem \
  --from-file=etcd-client.key=/etc/kubernetes/pki/etcd.key \
  --from-file=etcd-client.crt=/etc/kubernetes/pki/etcd.cert

  // experiment with https://docs.cilium.io/en/stable/operations/performance/tuning/ given Supported NICs for BIG TCP: mlx4, mlx5, ice exists
  //// check if --allocate-node-cidrs true in kube-controller-manager
API_SERVER_IP=10.0.16.5
helm template cilium/cilium --version v1.16.4 --namespace kube-system \
--set etcd.enabled=true --set etcd.ssl=true \
--set "etcd.endpoints[0]=https://10.0.16.5:2379" \
--set "etcd.endpoints[1]=https://10.0.16.6:2379" \
--set "etcd.endpoints[2]=https://10.0.16.7:2379" \
--set identityAllocationMode=kvstore \
--set kubeProxyReplacement=true \
--set bpf.hostLegacyRouting=false \
--set tunnelProtocol=geneve \
--set enable-ipv4-masquerade=true \
--set bpf.masquerade=true \
--set enable-ipv4=true \
--set enable-ipv6=false \
--set clean-cilium-bpf-state=true \
--set preallocate-bpf-maps=true \
--set cni.install=true \
--set cni.exclusive=true \
--set ipv4NativeRoutingCIDR=10.244.0.0/16 \
--set ipam.operator.clusterPoolIPv4PodCIDRList=10.244.0.0/16 \
--set ipam.mode=cluster-pool \
--set monitor-aggregation=true \
--set bpf.disableExternalIPMitigation=true \
--set loadBalancer.algorithm=maglev \
--set k8sServiceHost=${API_SERVER_IP} \
--set k8sServicePort=6443 \
--set externalTrafficPolicy=Local \
--set hubble.relay.enabled=true \
--set hubble.ui.enabled=true \
--output-dir manifests

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

kubectl create -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/baremetal/deploy.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml

apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
name: staging-pool
namespace: metallb-system
spec:
addresses:
- 20.244.81.47/32

yum --setopt=tsflags=noscripts install device-mapper iscsi-initiator-utils nfs-utils
echo "InitiatorName=$(/sbin/iscsi-iname)" > /etc/iscsi/initiatorname.iscsi
systemctl enable iscsid
systemctl start iscsid
modprobe iscsi_tcp
