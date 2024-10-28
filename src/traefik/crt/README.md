# rancher-k3s-kubernetes

### navigate
```
cd ~/rancher-k3s-kubernetes/src/traefik/crt
```

### create secret
```
kubectl create secret tls mtls --cert=./selfsigned.crt --key=./selfsigned.key -n mnamespace
```

### remove secret
```
kubectl delete secret mtls -n mnamespace
```

### get secrets
```
kubectl get secrets -n mnamespace
```