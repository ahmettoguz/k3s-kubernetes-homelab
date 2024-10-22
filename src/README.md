------------------------------------------------------------------ run
kubectl apply -f app.yml

------------------------------------------------------------------ stop
kubectl delete -f app.yml
kubectl delete deployment app
kubectl delete service app

------------------------------------------------------------------ monitor
kubectl get deployments
kubectl get pods
kubectl get services

clear

------------------------------------------------------------------ host http request
curl -s http://139.179.104.206:30001
curl -s http://139.179.104.184:30001
curl -s http://139.179.104.186:30001
curl -s http://139.179.104.188:30001

cls

------------------------------------------------------------------
