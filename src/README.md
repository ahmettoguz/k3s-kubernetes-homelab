------------------------------------------------------------------ run
kubectl apply -f app.yaml

------------------------------------------------------------------ stop
kubectl delete -f app.yaml
kubectl delete deployment app
kubectl delete service app

------------------------------------------------------------------ monitor
kubectl get deployments
kubectl get pods
kubectl get services

------------------------------------------------------------------ browser
http://<node-ip>:30001

------------------------------------------------------------------
