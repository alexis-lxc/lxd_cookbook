# lxd_cookbook

This cookbook will enable you to setup following:
1. LXD 
2. Setup fan network
3. If you have setup sauron, then you can register this lxd host on sauron


## Attributes required:
1. underlay_network e.g. 192.168.0.0/16 i.e. a /16 network
2. Overlay_network e.g. 10.0.0.0/8 i.e a /8 network
3. network_bridge_name e.g fan-10
4. register_on_saruon e.g true or false
5. sauron_url_to_regsiter_lxd_host e.g http://172.16.2.220/container-hosts


## How to use it:

Just add the default recipe to the node runlist and pass required attributes


## How to run test locally

0. You need to have ruby installed
1. gem install bundler
2. kitchen verify

