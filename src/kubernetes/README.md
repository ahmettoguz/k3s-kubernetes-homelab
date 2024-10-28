# rancher-k3s-kubernetes

### navigate
```
cd ~/rancher-k3s-kubernetes/src/kubernetes
```

### check pods
```
kubectl get pods -n mnamespace -o wide
kubectl get pods -o wide --all-namespaces

kubectl describe node k3s-4
kubectl logs -n mnamespace mdeployment-6c9584c8d4-phq6q
kubectl logs -n mnamespace mdeployment-6c9584c8d4-qgsrv

kubectl get pods -o wide --all-namespaces
kubectl get deployments -n mnamespace
kubectl get pods -n mnamespace
kubectl get services -n mnamespace

clear
```

### apply kubernetes
```
kubectl apply -f app.yml
```

### remove kubernetes
```
kubectl delete -f app.yml

kubectl delete namespace mnamespace

kubectl delete deployment app
kubectl delete service app

shutdown now

clear
```