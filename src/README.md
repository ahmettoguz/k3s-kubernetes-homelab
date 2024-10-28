------------------------------------------------------------------ run
kubectl apply -f app.yml

------------------------------------------------------------------ stop
kubectl delete -f app.yml
kubectl delete deployment app
kubectl delete service app

------------------------------------------------------------------ monitor
kubectl get nodes -o wide --all-namespaces
kubectl get pods -n mnamespace -o wide
kubectl get pods -o wide --all-namespaces

kubectl get deployments
kubectl get pods
kubectl get services

clear

------------------------------------------------------------------ host http request
curl -s http://192.168.1.137:30001
curl -s http://192.168.1.150:30001
curl -s http://192.168.1.151:30001
curl -s http://192.168.1.152:30001

curl -s http://192.168.1.152

curl -s www.bugday.org
curl www.bugday.org


cls

------------------------------------------------------------------
