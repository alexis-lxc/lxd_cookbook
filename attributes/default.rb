app_name = 'lxd'

default['app']['name']         = app_name
default['underlay_network']    = '172.16.0.0/16'
default['overlay_network']     = '10.0.0.0/8'
default['network_bridge_name'] = 'fan10'
default['register_on_sauron']  = 'false'
default['first_node_in_cluster'] = 'true'
