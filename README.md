<h1 id="top" align="center">K3s Kubernetes <br/> Homelab</h1> 

<br>

<div align="center">
    <img width=300 src="src/main/resources/assets/banner/banner.png">
</div>

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

### DevOps

&nbsp; [![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

### Web

&nbsp; [![Java](https://img.shields.io/badge/java-%23ED8B00.svg?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com/)

&nbsp; [![Spring](https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white)](https://spring.io/)

&nbsp; [![Spring Boot](https://img.shields.io/badge/Spring_Boot-F2F4F9?style=for-the-badge&logo=spring-boot)](https://spring.io/projects/spring-boot)

&nbsp; [![Apache Tomcat](https://img.shields.io/badge/apache%20tomcat-%23F8DC75.svg?style=for-the-badge&logo=apache-tomcat&logoColor=black)](https://tomcat.apache.org/)

&nbsp; [![Swagger](https://img.shields.io/badge/Swagger-85EA2D?style=for-the-badge&logo=Swagger&logoColor=white)](https://swagger.io/)

### Test

&nbsp; [![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)](https://www.postman.com/)

<br/>

<h2 id="features">🔥 Features</h2>

+ **TLS/HTTPS:** Centeralized TLS/HTTPS support for all services with selfsigned certificate.
+ **External Communication:** Manage communication with frontend.
+ **Postman Endpoint Collection:** Postman collection added for ensure validation of all API endpoints.
+ **Swagger Documentation:** Comprehensive API documentation integrated for documentation and testing purposes.
+ **Environment Configuration:** Configurations have been adjusted for enhanced flexibility.
+ **Dockerization:** The application is containerized for consistent deployment and scaling.

<br/>

<h2 id="prerequisites">🔒 Prerequisites</h2>

VirtualBox must be installed on your local machine to create and manage the virtual machines required for the Kubernetes cluster setup.

<br/>

* Go to your Google Account settings at [`myaccount.google.com`](https://myaccount.google.com/).
* In the navigation panel, select [`Security`](https://myaccount.google.com/security).
* Under `How you sign in to Google`, select `2-Step Verification`.
* Add your phone number as a verification method.
* Go to  [`myaccount.google.com/u/1/apppasswords`](https://myaccount.google.com/u/1/apppasswords) and generate a new app password.

<br/>

<h2 id="system-startup">🚀 System Startup</h2> 

<h3 id="developer-mode">🧪 Developer Mode</h3>

* Place credentials in the `application-dev.properties` file.

<br/>

#### Using command line

```
mvnw spring-boot:run
```

#### Using Docker

```
docker build -t micro-email-image .

docker run -d -p 8082:80 --name micro-email-container micro-email-image

docker ps -a

docker rm -f micro-email-container
```

<br/>

<h3 id="production-mode">⚡Production Mode</h3> 

* Copy `application-dev.properties` to create `application-prod.properties`.
* Change `app.var.appMode` to `prod`.
* Change `server.port` to `80`.
* Place credentials.
* Follow the instructions in the [`Micro-Docker-Config repository`](https://github.com/ahmettoguz/Micro-Docker-Config) to configure Docker for production.

<br/>

<h2 id="endpoint-documentation">📍 Endpoint Documentation</h2>
You can access the full API documentation using Swagger UI.

To view the documentation visit: [`sw/swagger-ui/index.html`](https://email.localhost/sw/swagger-ui/index.html)

![endpoint-doc](src/main/resources/assets/endpoint-doc/endpoint-doc.png)

<br/>

<h2 id="contributors">👥 Contributors</h2> 

<a href="https://github.com/ahmettoguz" target="_blank"><img width=60 height=60 src="https://avatars.githubusercontent.com/u/101711642?v=4"></a> 

### [🔝](#top)






_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

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
`--flannel-backend=none`: Do not install flannel as default.
`--disable-network-policy`: Do not use network policy which flannel provide.

#### k3s1 (master, server)
After installation on k3s1 install Calico.
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --cluster-init --node-ip 192.168.56.31 --flannel-backend=none --disable-network-policy
```    

##### k3s-2 (master, server)
```
curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --server https://192.168.56.31:6443 --node-ip 192.168.56.32 --flannel-backend=none --disable-network-policy
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
As flannel cannot handle pod connectivity between different nodes I prefer to use Calico. Lets install Calico on k3s1.
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
Allow CoreDNS DNS resolution (port 53, 9153)
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
ufw allow 9153/udp
ufw allow 2379:2380/tcp
ufw allow 30000:32767/tcp
ufw allow 4789/udp
ufw allow 5473/tcp
ufw allow 179/tcp
ufw allow 22/tcp

ufw enable
```
