required_params = {}
required_params[:underlay_network] = node['underlay_network']
required_params[:overlay_network] = node['overlay_network']
required_params[:network_bridge_name] = node['network_bridge_name']
required_params[:register_on_sauron] = node['register_on_sauron']

required_params.each do |key, value|
  if value.nil?
    Chef::Log.error("Required parameter missing: #{key}")
    fail
  end
  if required_params[:register_on_sauron] == 'true' and node['sauron_url_to_regsiter_lxd_host'].nil?
    Chef::Log.error("Required parameter missing: sauron_url_to_regsiter_lxd_host")
    fail
  end
end

ip_address =  node['ipaddress']

apt_update
apt_package 'ubuntu-fan'
execute 'setup fan network' do
  command "sudo fanctl up -u #{required_params[:underlay_network]} -o #{required_params[:overlay_network]} --bridge=#{required_params[:network_bridge_name]} --dhcp"
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
  variables(:network_bridge_name =>  required_params[:network_bridge_name],
            :ssh_authrized_key => node['ssh_authorized_key'])
end

execute 'edit default profile' do
  command "cat /etc/default/lxd_profile | sudo lxc profile edit default"
end

if required_params[:register_on_sauron] == 'true'
  http_request 'register host with sauron' do
    action :post
    url required_params[:sauron_url_to_regsiter_lxd_host]
    message ({:hostname => node['hostname'], :ipaddress => node['ipaddress']}.to_json)
    headers({
      'Content-Type' => 'application/json'
    })
  end
end
