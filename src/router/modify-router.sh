#!/bin/bash

ip route del 10.42.2.0/24 dev flannel.1 onlink
ip route add 10.42.2.0/24 via 192.168.56.33