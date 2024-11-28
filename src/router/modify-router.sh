#!/bin/bash
ip route del 10.42.1.0/24 dev flannel.1 onlink
ip route del 10.42.2.0/24 dev flannel.1 onlink
ip route del 10.42.3.0/24 dev flannel.1 onlink
