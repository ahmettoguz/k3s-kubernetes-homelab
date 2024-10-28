------------------------------------------------------------------ run
kubectl apply -f app.yml

------------------------------------------------------------------ stop
kubectl delete -f app.yml
kubectl delete deployment app
kubectl delete service app

shutdown now

------------------------------------------------------------------ monitor
kubectl get nodes -o wide --all-namespaces
kubectl get pods -n mnamespace -o wide

kubectl describe node k3s-4
kubectl logs -n mnamespace mdeployment-6c9584c8d4-phq6q
kubectl logs -n mnamespace mdeployment-6c9584c8d4-qgsrv

kubectl get pods -o wide --all-namespaces
kubectl get deployments
kubectl get pods
kubectl get services

clear

------------------------------------------------------------------ ingress resource
kubectl get svc -n kube-system

kubectl get ingress -n mnamespace


clear

------------------------------------------------------------------ host http request
curl -s http://192.168.1.137:30001
curl -s http://192.168.1.150:30001
curl -s http://192.168.1.151:30001
curl -s http://192.168.1.152:30001

curl -s http://192.168.1.152

curl -s www.bugday.org:30001
curl www.bugday.org


cls

------------------------------------------------------------------
