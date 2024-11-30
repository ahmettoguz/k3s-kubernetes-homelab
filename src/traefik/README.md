# k3s-kubernetes-homelab

### navigate
```
cd ~/k3s-kubernetes-homelab/src/traefik
```

### check ingress
```
kubectl get ingress -n mnamespace

kubectl get svc -n kube-system

clear
```

### apply ingress
```
kubectl apply -f ingress.yml
```

### remove ingress
```
kubectl delete -f ingress.yml
```