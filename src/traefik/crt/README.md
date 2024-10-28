# Create kubernetes secret

### get secrets
```
kubectl get secrets -n mnamespace
```

### remove secret
```
kubectl delete secret my-tls-secret -n mnamespace
```


### Create new secret
```
kubectl create secret tls my-tls-secret --cert=./selfsigned.crt --key=./selfsigned.key -n mnamespace
```
