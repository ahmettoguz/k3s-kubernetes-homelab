# rancher-k3s-kubernetes

### navigate
```
cd ~/rancher-k3s-kubernetes/src/traefik
```

### apply ingress
```
kubectl apply -f ingress.yml
```

### remove ingress
```
kubectl delete -f ingress.yml
```

### check status
```
kubectl get ingress -n mnamespace

kubectl get svc -n kube-system

clear
```