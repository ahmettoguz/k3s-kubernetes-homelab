# rancher-k3s-kubernetes

### navigate
```
cd ~/rancher-k3s-kubernetes/src/traefik/crt
```

### get secrets
```
kubectl get secrets -n mnamespace
```

### create secret
```
kubectl create secret tls my-tls-secret --cert=./selfsigned.crt --key=./selfsigned.key -n mnamespace
```

### remove secret
```
kubectl delete secret my-tls-secret -n mnamespace
```