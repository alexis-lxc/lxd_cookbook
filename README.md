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
6. ssh_authorized_key. It is used to get access to a newly created
   container. Pass any ssh key u want to access the container with. This
   goes to the default profile.
7. lxd_cluster_password. It is the password required to join the
   cluster. The default value is 'ubuntu'.
8. lxd_cluster_address. It is required while bootstrapping the second
   node in the cluster. The process will use this address to join an
   existing node running in cluster mode.
9. cluster_certificate. This is the LXD ssl certificate generated at
   the first node. The 2nd node which wants to join the cluster needs to
   provide the certificate of the first node.

## Manual Step in setting up a new LXD cluster
### Context:
   1. In clustering mode, the LXD nodes communicate using SSL. The first
      node in the cluster generates its SSL certificate. It is a self
      signed certificate by default.
   2. Any new node joining the cluster needs to explicitly trust the certificate
      provided by the first node. Unfortunately this is not possible in the
      preseed setup that we are using in this cookbook. In preseed, the
      joining node need to provide the certificate of the first node, in
      its preseed.yaml.
   3. This certificate we cannot get from the first node in this cookbook
      run. So this remains a manual step.
   4. The idea is that, you bootstrap the first node, ssh into that node.
      The copy that server.crt. You can access it using `lxc info` or
      `cat /var/snap/lxd/common/lxd/server.crt`. The we need a created
      string for this cert for passing it as a node attribute.

### Steps:
   1. ssh into first node.
   2. copy the cert `cat /var/snap/lxd/common/lxd/server.crt`.
   3. install ruby.
   4. open irb.
   5. run `sed ':a;N;$!ba;s/\\n/\\n\\n/g' /var/snap/lxd/common/lxd/server.crt`
   6. copy the cert string and paste it into node attribute cluster_certificate.

## How to use it:

1. Add the lxd_cluster recipe to the FIRST node in the cluster. Override the default
   attributes if required.
2. Add the add_node_to_lxd_cluster to any additional nodes which are
   joining an existing cluster.


## How to run test locally

0. You need to have ruby installed
1. gem install bundler
2. kitchen verify

