<h1 id="top" align="center">K3s Kubernetes Homelab</h1> 

<br>

<div align="center">
    <img height=400 src="assets/banner1.png">
</div>

<br>

## 🔍 Table of Contents

- [About Project](#intro)
- [Technologies](#technologies)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [System Startup](#system-startup)
- [Contributors](#contributors)
 
<br/>

<h2 id="intro">📌 About Project</h2> 

   In this project, I designed and deployed a Kubernetes cluster using K3s, a lightweight Kubernetes distribution. The cluster consists of four virtual machines (VMs), including two master nodes and two worker nodes. I configured the network interfaces for these VMs with both NAT and Host-Only networking, assigned static IP addresses, and set up a local DNS for internal name resolution. Additionally, I configured firewalls on each VM to enhance the overall security of the environment.

   For container networking, I implemented Calico as the Container Network Interface (CNI) solution, which provides efficient IP address management and network policy enforcement. As flannel fail to manage cross pod communication. I deployed two applications with replicas to ensure fault tolerance and load balancing. To manage incoming traffic and provide reverse proxy functionality, I used Traefik as the ingress controller. I configured centralized TLS/HTTPS encryption with self-signed certificates through Traefik, securing communication across the cluster.

To streamline application deployment and management, I installed Helm. I also used Cert Manager to handle the installation and management of Rancher Server via Helm.

<br/>

<h2 id="technologies">☄️ Technologies</h2>

### Operating System

&nbsp; [![DEBIAN](https://img.shields.io/badge/Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white)](https://www.debian.org/)

### Virtualization

&nbsp; [![VIRTUALBOX](https://img.shields.io/badge/VirtualBox-%231867d0.svg?style=for-the-badge&logo=virtualbox&logoColor=white)](https://virtualbox.org/)

### DevOps

&nbsp; [![Kubernetes](https://img.shields.io/badge/Kubernetes-3069DE?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)

&nbsp; [![K3S](https://img.shields.io/badge/K3S-FFC61C?style=for-the-badge&logo=k3s&logoColor=black)](https://k3s.io/)

&nbsp; [![RANCHER](https://img.shields.io/badge/Rancher-0075A8?style=for-the-badge&logo=rancher&logoColor=white)](https://www.rancher.com/)

&nbsp; [![CALICO](https://img.shields.io/badge/CALICO-E34C26?style=for-the-badge&logoColor=black)](https://www.projectcalico.org/)

&nbsp; [![Traefik](https://img.shields.io/badge/Traefik-24A1C1?style=for-the-badge&logo=traefikproxy&logoColor=black)](https://traefik.io/)

&nbsp; [![Helm](https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=Helm&labelColor=0F1689)](https://helm.sh/)

&nbsp; [![CoreDNS](https://img.shields.io/badge/CoreDNS-%233991e1.svg?style=for-the-badge&logo=coredns&logoColor=white)](https://coredns.io/)

&nbsp; [![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

### Web Server

&nbsp; [![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)](https://www.nginx.com/)

<br/>

<h2 id="features">🔥 Features</h2>

+ **K3s Cluster Deployment:** Lightweight Kubernetes cluster deployed using K3s.
+ **Calico CNI:** Efficient IP address management and network policy enforcement using Calico as the Container Network Interface.
+ **Network Adapter Setup:** VMs configured with both NAT and Host-Only networking for isolated lab environment.
+ **Static IP Configuration:** Static IP addresses assigned to each VM for stable networking within the cluster.
+ **Local DNS:** Local DNS setup for internal name resolution across the Kubernetes cluster.
+ **Ingress Controller:** Traefik used as the ingress controller for reverse proxy functionality.
+ **TLS/HTTPS:** Centralized TLS/HTTPS encryption for all services using self-signed certificates through Traefik.
+ **Fault Tolerance & Load Balancing:** Applications deployed with replicas to ensure fault tolerance and effective load balancing.
+ **Helm Integration:** Helm installed to simplify the deployment and management of Kubernetes applications.
+ **Rancher Server Management:** Rancher Server installed and managed via Helm for centralized Kubernetes cluster management.
+ **Firewall Security:** Firewalls configured on each VM to enhance overall security of the Kubernetes environment.

<br/>

<h2 id="prerequisites">🔒 Prerequisites</h2>

VirtualBox must be installed on your local machine to create and manage the VMs required for the Kubernetes cluster setup.

<br/>

<h2 id="system-startup">🚀 System Startup</h2> 

### VMs Setup
Create four VMs named k3s1 to k3s4. Configure the master nodes (k3s1 and k3s2) with 2 CPUs and 2GB RAM each, and the worker nodes (k3s3 and k3s4) with 1 CPU and 512MB RAM each.

<br/>

### SSH Configuration
Modify the `/etc/ssh/sshd_config` file to enable root login via SSH.
```
PermitRootLogin yes
```

<br/>

### Configure Network Devices

To ensure a stable Kubernetes cluster installation and proper functionality after a reboot, static IP addresses need to be assigned to the VMs. This requires adding network devices to the VMs.
For detailed configuration instructions, refer to `/assets/guide/network-configuration`.

<br/>

### Connect VMs via SSH
Use the password `toor` to log in.

#### k3s1
```
ssh -p 3021 root@localhost
```

#### k3s2
```
ssh -p 3022 root@localhost
```

#### k3s3
```
ssh -p 3023 root@localhost
```

#### k3s4
```
ssh -p 3024 root@localhost
```

<br/>


### Update, Upgrade, and Install Required Tools
```
apt update && apt upgrade -y
apt install curl git ufw -y
```

<br/>

### Install k3s on Nodes
Follow these steps to install k3s on the nodes. The parameters are explained below:

* `--flannel-backend=none`: Prevents the installation of Flannel as the default CNI.
* `--disable-network-policy`: Disables network policies that are typically provided by Flannel.

#### k3s1 (Master, Server)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --cluster-init --node-ip 192.168.56.31 --flannel-backend=none --disable-network-policy
```    
After installation on k3s1 install Calico as stated in the next step.

##### k3s2 (Master, Server)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --server https://192.168.56.31:6443 --node-ip 192.168.56.32 --flannel-backend=none --disable-network-policy
```

##### k3s3 (Worker, Agent)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - agent --server https://192.168.56.31:6443 --node-ip 192.168.56.33
```

##### k3s4 (Worker, Agent)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - agent --server https://192.168.56.31:6443 --node-ip 192.168.56.34
```

<br/>

### Install Calico
Since Flannel cannot manage pod connectivity across different nodes, we will use Calico instead. To install Calico on k3s1, run the following command:
```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml
```

<br/>

### Clone Project to k3s1 Master Node
```
cd /root
git clone https://github.com/ahmettoguz/k3s-kubernetes-homelab
```

<br/>

### Run Kubernetes and Deploy Application
```
cd /root/k3s-kubernetes-homelab/src/kubernetes
kubectl apply -f app.yml
```

### Activate Ingress
```
cd /root/k3s-kubernetes-homelab/src/traefik
kubectl apply -f ingress.yml
```

<br/>

### Configure Local DNS
Add the following two lines to the end of the file:
For Linux: `/etc/hosts`
For Windows: `C:\Windows\System32\drivers\etc\hosts`
```
192.168.56.31 www.bugday.org
192.168.56.31 www.ctis486.com
```

<br/>

### Client Request Using CMD
```
curl -s -k https://www.bugday.org
curl -s -k https://www.ctis486.com
```

<br/>

### Helm Installation on k3s1
```
curl -fsSL https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz -o helm.tar.gz
tar -zxvf helm.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
rm -r helm.tar.gz
rm -r linux-amd64
helm version
```

<br/>

### Cert Manager (CRD) Installation
```
curl -LO https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
kubectl  apply -f cert-manager.crds.yaml
```

<br/>

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
The following firewall rules should be applied to ensure secure communication and proper functioning of your Kubernetes cluster:
* `Port 6443:` Allow API server communication
* `Port 10255:` Allow kubelet read-only API
* `Port 10250:` Allow communication between kubelet and master node
* `Port 10256:` Allow kube-proxy
* `Port 53, 9153:` Allow CoreDNS DNS resolution
* `Port range 2379-2380:` Allow etcd
* `Port range 30000-32767:` Allow NodePort services
* `Port 4789:` Allow VXLAN encapsulation
* `Port 5473:` Allow Calico control plane communication
* `Port 22:` Allow SSH
* `Port 80:` Allow HTTP
* `Port 443:` Allow HTTPS

```
ufw allow 6443/tcp
ufw allow 10250/tcp
ufw allow 10255/tcp
ufw allow 10256/tcp
ufw allow 53/tcp
ufw allow 53/udp
ufw allow 9153/udp
ufw allow 2379:2380/tcp
ufw allow 30000:32767/tcp
ufw allow 4789/udp
ufw allow 5473/tcp
ufw allow 179/tcp
ufw allow 22/tcp

ufw enable
```

<br/>

<h2 id="contributors">👥 Contributors</h2> 

<a href="https://github.com/ahmettoguz" target="_blank"><img width=60 height=60 src="https://avatars.githubusercontent.com/u/101711642?v=4"></a> 

### [🔝](#top)
