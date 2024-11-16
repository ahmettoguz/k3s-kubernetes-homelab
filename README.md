# rancher-k3s-kubernetes

## Document

#### Connect VM
    s3k-1
    ssh root@192.168.1.21

    s3k-2
    ssh root@192.168.1.22

    s3k-3
    ssh root@192.168.1.23

    s3k-4
    ssh root@192.168.1.24

    toor
    exit
    clear

#### Set Static IP
    For stable kubernetes cluster installation we need static ip addresses.
    So that we will add network devices to vms.

    check ip address with subnet mask.
    Define usable ip range.
    My ip adress is: 192.168.1.31 and subnet is /24
    So that usable ip range is 192.168.1.1 - 192.168.1.254
    Wee need to find selected ip address already to be able to assign unique ip address.
    lets install nmap tool for that in vm.
    apt install nmap
    nmap -sn 192.168.1.0/24
    for my vms I choose to set 192.168.1.21 to 192.168.1.24.
    check guide/static-ip for static ip configurations.

#### Install k3s to Nodes
    ##### k3s-1 (master) 
        curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --cluster-init
        curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --cluster-init --node-taint role=master:NoSchedule

    ##### k3s-2 (master)
        curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --server https://192.168.1.21:6443
        curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --node-taint role=master:NoSchedule --server https://192.168.1.21:6443

    ##### k3s-3, k3s-4 (worker)
        curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - agent --server https://192.168.1.21:6443

### Check Nodes
    kubectl get nodes -o wide --all-namespaces
    kubectl describe node k3s-4
    clear

### Clone Project to k3s-1 Node
cd /root
git clone https://github.com/ahmettoguz/rancher-k3s-kubernetes

### Run Kubernetes
cd /root/rancher-k3s-kubernetes/src/kubernetes
kubectl apply -f app.yml

### Check Container Status
kubectl get deployments -n mnamespace
kubectl get pods -n mnamespace -o wide
clear

### Activate Ingress
cd /root/rancher-k3s-kubernetes/src/traefik
kubectl apply -f ingress.yml

### Check Ingress Status
    kubectl get ingress -n mnamespace
    kubectl get svc -n kube-system
    clear

### On host machine (mine is Windows) Configure Dns
    On folder: C:\Windows\System32\drivers\etc
    File: hosts

    add that 2 line at the end of the file:
        192.168.1.21 www.bugday.org
        192.168.1.21 www.ctis486.com


### Client Request with CMD
    curl -s -k https://www.bugday.org
    curl -s -k https://www.ctis486.com

#### Down Node to Test
    kubectl get nodes -o wide --all-namespaces
    kubectl get pods -n mnamespace -o wide
    shutdown now

    when node is shutdown get nodes should display NotReady
    when get pods, it should generate replacement pods on other node

#### Helm Installation
    curl -fsSL https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz -o helm.tar.gz
    tar -zxvf helm.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm
    rm -r helm.tar.gz
    rm -r linux-amd64
    helm version


### Cert Manager (CRD)
    curl -LO https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
    kubectl apply -f cert-manager.crds.yaml

#### Rancher Installation
    helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
    helm repo update

    kubectl create namespace cattle-system
    kubectl get namespaces
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

    kubectl get nodes -o wide
    helm install rancher rancher-latest/rancher --namespace cattle-system --set ingress.enabled=false
    helm install rancher rancher-latest/rancher --namespace cattle-system

### Check Rancher Installation

kubectl get nodes

kubectl get deployment -n cattle-system
kubectl get pods -n cattle-system
kubectl get svc -n cattle-system


ls
clear

#### Rancher Installation
helm uninstall rancher -n cattle-system

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set ingress.enabled=false \
  --set certificates.k8sSecret=false \
  --set certManager.create=false \
  --set extraEnv[0].name=CATTLE_BOOTSTRAP_PASSWORD \
  --set extraEnv[0].value=yourpassword


kubectl patch svc rancher -n cattle-system -p '{"spec": {"type": "NodePort"}}'


http://192.168.1.21:30129
http://192.168.1.21:31530