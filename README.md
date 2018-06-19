# lxd_cookbook

This cookbook will enable you to setup following:
1. LXD 
2. Setup fan network
3. If you have setup sauron, then you can register this lxd host on sauron


## Attributes:
1. underlay_network. Default value is 172.16.0.0/16 i.e. a /16 network
2. Overlay_network. Default value is 10.0.0.0/8 i.e a /8 network
3. network_bridge_name. Default value is fan10
4. register_on_saruon [Sauron](https://github.com/alexis-lxc/sauron). Default is false.
5. sauron_url_to_regsiter_lxd_host e.g http://172.16.2.220/container-hosts.
   This is a required attribute if register_on_sauron is true.


## How to use it:

Add the default recipe to the node runlist. Override the default
attributes if required.


## How to run test locally

0. You need to have ruby installed
1. gem install bundler
2. kitchen verify

