### 🚀🚀🚀 Dev Commands 🚀🚀🚀

### Check Nodes
```
kubectl get nodes -o wide --all-namespaces
kubectl describe node k3s1
systemctl status k3s
```

### Check Container Status
```
kubectl get nodes -o wide --all-namespaces
kubectl get deployments -n mnamespace
kubectl get pods -n mnamespace -o wide
kubectl get deployments --all-namespaces
kubectl get pods --all-namespaces
```

### Check Ingress Status
```
kubectl get ingress -n mnamespace
kubectl get svc -n kube-system
```

<br/>

### Kubernetes Actions
```
cd /root/k3s-kubernetes-homelab/src/kubernetes
kubectl apply -f app.yml
kubectl delete -f app.yml

cd /root/k3s-kubernetes-homelab/src/traefik
kubectl apply -f ingress.yml
kubectl delete -f ingress.yml
```

<br/>

## Uninstall k3s
Uninstall k3s for server (master)

```
/usr/local/bin/k3s-uninstall.sh
```

Uninstall k3s for agent (worker)

```
/usr/local/bin/k3s-agent-uninstall.sh
```

Remove node from cluster without uninstall
```
kubectl delete node k3s3
```

<br/>

### Cert Manager (CRD)
```
kubectl delete -f cert-manager.crds.yaml
```

<br/>

### Rancher
```
kubectl get namespaces

kubectl get deployment -n cattle-system
kubectl get pods -n cattle-system
kubectl get svc -n cattle-system

kubectl delete pod rancher-8458c97cfd-cxvdd -n cattle-system --force --grace-period=0
```