# k3s-kubernetes-homelab

Create 4 VMs as k3s1 to k3s4.

### SSH
Configure `/etc/ssh/sshd_config` to be able to login as root.
```
PermitRootLogin yes
```

<br/>
-------------------------------------------------------------------------------------------------------------

### Configure Network Devices
For stable kubernetes cluster installation and runtime on reboot we need to set static ip addresses to VMs.
So that we will add network devices to VMs.
Check detailed configuration from `/assets/guide/network-configuration`.

<br/>
-------------------------------------------------------------------------------------------------------------

### Connect VM via SSH
Password is `toor`.

#### s3k1
```
ssh -p 3021 root@localhost
```

#### s3k2
```
ssh -p 3022 root@localhost
```

#### s3k3
```
ssh -p 3023 root@localhost
```

#### s3k4
```
ssh -p 3024 root@localhost
```

toor
clear

<br/>
-------------------------------------------------------------------------------------------------------------

### Update Upgrade and install Required tools
```
apt update && apt upgrade -y
apt install curl git ufw -y
```

<br/>
-------------------------------------------------------------------------------------------------------------

### Install k3s to Nodes
These are how installing k3s to nodes. Explanation of the parameters as follows:
`--node-taint dedicated=master:NoSchedule`: Master node will not schedule application pod.
`--flannel-backend=none`: Do not install flannel as default.
`--disable-network-policy`: Do not use network policy which flannel provide.

#### k3s1 (master, server) 
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --cluster-init --node-ip 192.168.56.31 --node-taint dedicated=master:NoSchedule --flannel-backend=none --disable-network-policy
```    

##### k3s-2 (master, server)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --server https://192.168.56.31:6443 --node-ip 192.168.56.32 --node-taint dedicated=master:NoSchedule --flannel-backend=none --disable-network-policy
```

##### k3s-3 (worker, agent)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - agent --server https://192.168.56.31:6443 --node-ip 192.168.56.33
```

##### k3s-4 (worker, agent)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - agent --server https://192.168.56.31:6443 --node-ip 192.168.56.34
```

<br/>
-------------------------------------------------------------------------------------------------------------

### Install Calico
As flannel cannot handle pod connectivity between different nodes I prefer to use Calico. Lets install Calico.
```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml
```

<br/>
-------------------------------------------------------------------------------------------------------------

### Clone Project to k3s1 Master Node
```
cd /root
git clone https://github.com/ahmettoguz/k3s-kubernetes-homelab
```

clear
<br/>
-------------------------------------------------------------------------------------------------------------

### Run Kubernetes
```
cd /root/k3s-kubernetes-homelab/src/kubernetes
kubectl apply -f app.yml
```

clear
<br/>
-------------------------------------------------------------------------------------------------------------

### Activate Ingress
```
cd /root/k3s-kubernetes-homelab/src/traefik
kubectl apply -f ingress.yml
```

clear
<br/>
-------------------------------------------------------------------------------------------------------------

### Configure Local DNS
add that 2 line at the end of the file:
Linux: `/etc/hosts`
Windows: `C:\Windows\System32\drivers\etc\hosts`
```
192.168.56.31 www.bugday.org
192.168.56.31 www.ctis486.com
```

clear
<br/>
-------------------------------------------------------------------------------------------------------------

### Client Request with CMD
```
curl -s -k https://www.bugday.org
curl -s -k https://www.ctis486.com
```

clear
<br/>
-------------------------------------------------------------------------------------------------------------

#### Helm Installation on k3s1
```
curl -fsSL https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz -o helm.tar.gz
tar -zxvf helm.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
rm -r helm.tar.gz
rm -r linux-amd64
helm version
```

clear
<br/>
-------------------------------------------------------------------------------------------------------------

### Cert Manager (CRD)
```
curl -LO https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
kubectl  apply -f cert-manager.crds.yaml
```

clear
<br/>
-------------------------------------------------------------------------------------------------------------

#### Rancher Installation
```
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update

kubectl create namespace cattle-system
kubectl get namespaces
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set ingress.enabled=false \
  --set certificates.k8sSecret=false \
  --set certManager.create=false \
  --set extraEnv[0].name=CATTLE_BOOTSTRAP_PASSWORD \
  --set extraEnv[0].value=yourpassword

helm install rancher rancher-latest/rancher --namespace cattle-system --set ingress.enabled=false
helm uninstall rancher --namespace cattle-system
helm install rancher rancher-latest/rancher --namespace cattle-system

kubectl get namespaces
kubectl get all -n cattle-system
kubectl -n cattle-system get pods

kubectl patch svc rancher -n cattle-system -p '{"spec": {"type": "NodePort"}}'

http://192.168.1.21:30129
http://192.168.1.21:31530
```
<br/>

### Apply Firewall

Allow API server communication (port 6443)
Allow kubelet read-only API (port 10255)
Allow communication between kubelet and master node (port 10250)
Allow kube-proxy (port 10256)
Allow CoreDNS DNS resolution (port 53)
Allow etcd (port range 2379-2380)
Allow NodePort services (port range 30000-32767)
Allow VXLAN encapsulation (port 4789)
Allow Calico control plane communication (port 5473)
Allow SSH (port 22)
Allow HTTP (port 80)
Allow HTTPS (port 443)

```
ufw allow 6443/tcp
ufw allow 10250/tcp
ufw allow 10255/tcp
ufw allow 10256/tcp
ufw allow 53/tcp
ufw allow 53/udp
ufw allow 2379:2380/tcp
ufw allow 30000:32767/tcp
ufw allow 4789/udp
ufw allow 5473/tcp
ufw allow 179/tcp
ufw allow 22/tcp

ufw enable
```