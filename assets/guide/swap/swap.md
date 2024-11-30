### Swap

Check description from pdf file. These are the commands used.

```
lsblk
fdisk /dev/sdb
n
p
1
w
lsblk
Format Partiton and Save as Persistent
swapon --show
mkswap /dev/sdb1
swapon /dev/sdb1
echo '/dev/sdb1 none swap sw 0 0' | tee -a /etc/fstab
reboot
swapon --show
free -h
```