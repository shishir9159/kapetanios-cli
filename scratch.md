helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
--timeout 600s \
--set global.hosts.domain=example.com \
--set global.hosts.externalIP=10.10.10.10 \
--set certmanager-issuer.email=me@example.com

resource mapping not found for name: "gitlab-gitaly" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-gitlab-shell" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-kas" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-sidekiq-all-in-1-v1" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-webservice-default" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-minio-v1" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-nginx-ingress-controller" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-registry-v1" namespace: "default" from "gitlab.yaml": no matches for kind "PodDisruptionBudget" in version "policy/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-gitlab-shell" namespace: "default" from "gitlab.yaml": no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-kas" namespace: "default" from "gitlab.yaml": no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-sidekiq-all-in-1-v2" namespace: "default" from "gitlab.yaml": no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-webservice-default" namespace: "default" from "gitlab.yaml": no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-registry" namespace: "default" from "gitlab.yaml": no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-kas" namespace: "default" from "gitlab.yaml": no matches for kind "Ingress" in version "extensions/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-webservice-default" namespace: "default" from "gitlab.yaml": no matches for kind "Ingress" in version "extensions/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-minio" namespace: "default" from "gitlab.yaml": no matches for kind "Ingress" in version "extensions/v1beta1"
ensure CRDs are installed first
resource mapping not found for name: "gitlab-registry" namespace: "default" from "gitlab.yaml": no matches for kind "Ingress" in version "extensions/v1beta1"
ensure CRDs are installed first

-----------------------------------------

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

kubectl create -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
might be - --kubelet-insecure-tls in the deployment metrics-server

remove the service type from being nodeport, add hostport to containerport:
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/baremetal/deploy.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.8/config/manifests/metallb-native.yaml

apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
name: staging-pool
namespace: metallb-system
spec:
addresses:
- 20.244.81.47/32