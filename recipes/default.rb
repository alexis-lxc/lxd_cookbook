if node[:register_on_sauron] == 'true' and node['sauron_url_to_regsiter_lxd_host'].nil?
  Chef::Log.error("Required parameter missing: sauron_url_to_regsiter_lxd_host")
  fail
end

ip_address =  node['ipaddress']

apt_update
apt_package 'ubuntu-fan'
execute 'setup fan network' do
  command "sudo fanctl up -u #{node[:underlay_network]} -o #{node[:overlay_network]} --bridge=#{node[:network_bridge_name]} --dhcp"
  not_if 'fanctl show | grep fan'
end

apt_repository 'ubuntu-lxc' do
  uri 'ppa:ubuntu-lxc/lxc-stable'
end

bash 'setup lxd' do
  code <<-EOH
    sudo apt install -y -t xenial-backports lxd lxd-client
    lxd init --auto --network-address #{ip_address} --trust-password ubuntu
  EOH
end

template '/etc/default/lxd_profile' do
  source 'etc/default/lxd_profile.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(:network_bridge_name =>  node[:network_bridge_name],
            :ssh_authrized_key => node['ssh_authorized_key'])
end

execute 'edit default profile' do
  command "cat /etc/default/lxd_profile | sudo lxc profile edit default"
end

if node[:register_on_sauron] == 'true'
  http_request 'register host with sauron' do
    action :post
    url node[:sauron_url_to_regsiter_lxd_host]
    message ({:hostname => node['hostname'], :ipaddress => node['ipaddress']}.to_json)
    headers({
      'Content-Type' => 'application/json'
    })
  end
end
