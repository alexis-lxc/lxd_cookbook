if node[:register_on_sauron] == 'true' and node['sauron_url_to_regsiter_lxd_host'].nil?
  Chef::Log.error("Required parameter missing: sauron_url_to_regsiter_lxd_host")
  fail
end


if node[:lxd_cluster_address].nil? || node[:lxd_cluster_certificate].nil?
  Chef::Log.error("Required parameter missing: lxd_cluster_certificate or lxd_cluster_address")
  fail
end

node_ipaddress = node[:custom_ipaddress].nil? ? node[:ipaddress] : node[:custom_ipaddress]

apt_update

apt_package 'ubuntu-fan'
execute 'setup fan network' do
  command "sudo fanctl up -u #{node[:underlay_network]} -o #{node[:overlay_network]} --bridge=#{node[:network_bridge_name]} --dhcp"
  not_if 'fanctl show | grep fan'
end

execute 'remove default lxd' do
  command "sudo apt-get purge lxd* -y"
end

execute 'install lxd using snap' do
  command "sudo snap install lxd"
end

template '/etc/default/lxd_preseed.yml' do
  source 'etc/default/preseed_add_node.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(:host_ip_address =>  node_ipaddress,
            :hostname => node[:hostname],
            :lxd_cluster_password => node[:lxd_cluster_password],
            :lxd_cluster_address => node[:lxd_cluster_address],
            :overlay_network => node[:overlay_network],
            :underlay_network => node[:underlay_network],
            :network_bridge_name => node[:network_bridge_name],
            :lxd_cluster_certificate => node[:cluster_certificate])
end

execute "sleep test" do
  command "sleep 10"
end

execute 'lxd init' do
  command "cat /etc/default/lxd_preseed.yml | lxd init --preseed"
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
