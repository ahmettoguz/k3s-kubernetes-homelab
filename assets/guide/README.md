------------------------------------------------------------------ SSH connection
    s3k-1
    ssh ahmet@s3k-1
    ssh ahmet@139.179.104.206
    ping 139.179.104.206

    s3k-2
    ssh ahmet@s3k-2
    ssh ahmet@139.179.104.157
    ping 139.179.104.157

    s3k-3
    ssh ahmet@139.179.104.158
    ping 139.179.104.158

    s3k-4
    ssh ahmet@169.254.6.11
    ping 169.254.6.11

    ahmet
    su -
    toor
    exit
    clear

------------------------------------------------------------------ Update
    apt update
    apt upgrade

------------------------------------------------------------------ Allow firewall
    apt install ufw -y

    ufw status
    ufw disable
    ufw enable

    ufw allow ssh
    ufw allow 80/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 6443/tcp

    ufw default allow incoming
    ufw default allow outgoing

------------------------------------------------------------------ installation curl
    apt install curl -y
    curl

------------------------------------------------------------------ installation of k3s
    s3k-1
    curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --cluster-init 

    s3k-2
    curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - server --server https://169.254.9.227:6443

    s3k-3, s3k-4
    curl -sfL https://get.k3s.io | K3S_TOKEN=MTOKEN sh -s - agent --server https://169.254.9.227:6443

------------------------------------------------------------------ check cluster
    kubectl get nodes
    kubectl get pods --all-namespaces
    kubectl get pods
    kubectl get pods -o wide --all-namespaces

    clear
------------------------------------------------------------------ check service
    systemctl status k3s.service
    systemctl status k3s
    systemctl restart k3s

    clear
------------------------------------------------------------------ remove from cluster
    k3s-1
    kubectl delete node k3s-4

    clear
------------------------------------------------------------------ delete k3s from being node
    for server
    /usr/local/bin/k3s-uninstall.sh

    for agent
    /usr/local/bin/k3s-agent-uninstall.sh

    clear
------------------------------------------------------------------
cat /etc/rancher/k3s/k3s.yaml