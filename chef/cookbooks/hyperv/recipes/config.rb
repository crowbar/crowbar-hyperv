raise if not node[:platform] == 'windows'

nova_path = "C:\OpenStack\etc"

sqls = search(:node, "roles:database-server")
if sqls.length > 0
  sql = sqls[0]
  sql = node if sql.name == node.name
else
  sql = node
end
backend_name = sql[:database][:sql_engine]

database_address = Chef::Recipe::Barclamp::Inventory.get_network_by_type(sql, "admin").address if database_address.nil?
Chef::Log.info("database server found at #{database_address}")
db_conn_scheme = backend_name
database_connection = "#{db_conn_scheme}://#{node[:hyperv][:db][:user]}:#{node[:hyperv][:db][:password]}@#{database_address}/#{node[:hyperv][:db][:database]}"

rabbits = search(:node, "roles:rabbitmq-server")
if rabbits.length > 0
  rabbit = rabbits[0]
  rabbit = node if rabbit.name == node.name
else
  rabbit = node
end
rabbit_address = Chef::Recipe::Barclamp::Inventory.get_network_by_type(rabbit, "admin").address
Chef::Log.info("Rabbit server found at #{rabbit_address}")
rabbit_settings = {
  :address => rabbit_address,
  :port => rabbit[:rabbitmq][:port],
  :user => rabbit[:rabbitmq][:user],
  :password => rabbit[:rabbitmq][:password],
  :vhost => rabbit[:rabbitmq][:vhost]
}

apis = search(:node, "recipes:nova\\:\\:api")
if apis.length > 0 and !node[:nova][:network][:ha_enabled]
  api = apis[0]
  api = node if api.name == node.name
else
  api = node
end
admin_api_ip = Chef::Recipe::Barclamp::Inventory.get_network_by_type(api, "admin").address
admin_api_host = api[:fqdn]
# For the public endpoint, we prefer the public name. If not set, then we
# use the IP address except for SSL, where we always prefer a hostname
# (for certificate validation).

#public_api_host = api[:crowbar][:public_name]
#if public_api_host.nil? or public_api_host.empty?
#  unless api[:nova][:ssl][:enabled]
#    public_api_host = Chef::Recipe::Barclamp::Inventory.get_network_by_type(api, "public").address
#  else
#    public_api_host = 'public.'+api[:fqdn]
#  end
#end
#Chef::Log.info("Api server found at #{admin_api_host} #{public_api_host}")

dns_servers = search(:node, "roles:dns-server")
if dns_servers.length > 0
  dns_server = dns_servers[0]
  dns_server = node if dns_server.name == node.name
else
  dns_server = node
end
dns_server_public_ip = Chef::Recipe::Barclamp::Inventory.get_network_by_type(dns_server, "public").address
Chef::Log.info("DNS server found at #{dns_server_public_ip}")

glance_servers = search(:node, "roles:glance-server")
if glance_servers.length > 0
  glance_server = glance_servers[0]
  glance_server = node if glance_server.name == node.name
  glance_server_host = glance_server[:fqdn]
  glance_server_port = glance_server[:glance][:api][:bind_port]
  glance_server_protocol = glance_server[:glance][:api][:protocol]
  glance_server_insecure = glance_server_protocol == 'https' && glance_server[:glance][:ssl][:insecure]
else
  glance_server_host = nil
  glance_server_port = nil
  glance_server_protocol = nil
  glance_server_insecure = nil
end
Chef::Log.info("Glance server at #{glance_server_host}")

#vncproxies = search(:node, "recipes:nova\\:\\:vncproxy")
#if vncproxies.length > 0
#  vncproxy = vncproxies[0]
#  vncproxy = node if vncproxy.name == node.name
#else
#  vncproxy = node
#end
# For the public endpoint, we prefer the public name. If not set, then we
# use the IP address except for SSL, where we always prefer a hostname
# (for certificate validation).
#vncproxy_public_host = vncproxy[:crowbar][:public_name]
#if vncproxy_public_host.nil? or vncproxy_public_host.empty?
#  unless vncproxy[:nova][:novnc][:ssl][:enabled]
#    vncproxy_public_host = Chef::Recipe::Barclamp::Inventory.get_network_by_type(vncproxy, "public").address
#  else
#    vncproxy_public_host = 'public.'+vncproxy[:fqdn]
#  end
#end
#Chef::Log.info("VNCProxy server at #{vncproxy_public_host}")

def mask_to_bits(mask)
  octets = mask.split(".")
  count = 0
  octets.each do |octet|
    break if octet == "0"
    c = 1 if octet == "128"
    c = 2 if octet == "192"
    c = 3 if octet == "224"
    c = 4 if octet == "240"
    c = 5 if octet == "248"
    c = 6 if octet == "252"
    c = 7 if octet == "254"
    c = 8 if octet == "255"
    count = count + c
  end

  count
end

# build the public_interface for the fixed net
public_net = node["network"]["networks"]["public"]
fixed_net = node["network"]["networks"]["nova_fixed"]
nova_floating = node[:network][:networks]["nova_floating"]

node.set[:nova][:network][:fixed_range] = "#{fixed_net["subnet"]}/#{mask_to_bits(fixed_net["netmask"])}"
node.set[:nova][:network][:floating_range] = "#{nova_floating["subnet"]}/#{mask_to_bits(nova_floating["netmask"])}"

fip = Chef::Recipe::Barclamp::Inventory.get_network_by_type(node, "nova_fixed")
if fip
  fixed_interface = fip.interface
  fixed_interface = "#{fip.interface}.#{fip.vlan}" if fip.use_vlan
else
  fixed_interface = nil
end
pip = Chef::Recipe::Barclamp::Inventory.get_network_by_type(node, "public")
if pip
  public_interface = pip.interface
  public_interface = "#{pip.interface}.#{pip.vlan}" if pip.use_vlan
else
  public_interface = nil
end

flat_network_bridge = fixed_net["use_vlan"] ? "br#{fixed_net["vlan"]}" : "br#{fixed_interface}"

node.set[:nova][:network][:public_interface] = public_interface
if !node[:nova][:network][:dhcp_enabled]
  node.set[:nova][:network][:flat_network_bridge] = flat_network_bridge
  node.set[:nova][:network][:flat_interface] = fixed_interface
elsif !node[:nova][:network][:tenant_vlans]
  node.set[:nova][:network][:flat_network_bridge] = flat_network_bridge
  node.set[:nova][:network][:flat_interface] = fixed_interface
else
  node.set[:nova][:network][:vlan_interface] = fip.interface rescue nil
  node.set[:nova][:network][:vlan_start] = fixed_net["vlan"]
end

keystones = search(:node, "recipes:keystone\\:\\:server")
if keystones.length > 0
  keystone = keystones[0]
  keystone = node if keystone.name == node.name
else
  keystone = node
end

keystone_host = keystone[:fqdn]
keystone_protocol = keystone["keystone"]["api"]["protocol"]
keystone_token = keystone["keystone"]["service"]["token"]
keystone_service_port = keystone["keystone"]["api"]["service_port"]
keystone_admin_port = keystone["keystone"]["api"]["admin_port"]
keystone_service_tenant = keystone["keystone"]["service"]["tenant"]
keystone_service_user = node[:nova][:service_user]
keystone_service_password = node[:nova][:service_password]
Chef::Log.info("Keystone server found at #{keystone_host}")

cinder_servers = search(:node, "roles:cinder-controller") || []
if cinder_servers.length > 0
  cinder_server = cinder_servers[0]
  cinder_insecure = cinder_server[:cinder][:api][:protocol] == 'https' && cinder_server[:cinder][:ssl][:insecure]
else
  cinder_insecure = false
end

quantum_servers = search(:node, "roles:quantum-server")
if quantum_servers.length > 0
  quantum_server = quantum_servers[0]
  quantum_server = node if quantum_server.name == node.name
  quantum_protocol = quantum_server[:quantum][:api][:protocol]
  quantum_server_host = quantum_server[:fqdn]
  quantum_server_port = quantum_server[:quantum][:api][:service_port]
  quantum_insecure = quantum_protocol == 'https' && quantum_server[:quantum][:ssl][:insecure]
  quantum_service_user = quantum_server[:quantum][:service_user]
  quantum_service_password = quantum_server[:quantum][:service_password]
  if quantum_server[:quantum][:networking_mode] != 'local'
    per_tenant_vlan=true
  else
    per_tenant_vlan=false
  end
  quantum_networking_plugin = quantum_server[:quantum][:networking_plugin]
  quantum_networking_mode = quantum_server[:quantum][:networking_mode]
else
  quantum_server_host = nil
  quantum_server_port = nil
  quantum_service_user = nil
  quantum_service_password = nil
end
Chef::Log.info("Quantum server at #{quantum_server_host}")

directory "#{node[:openstack][:instances]}" do
  action :create
  recursive true
end

directory "#{node[:openstack][:config]}" do
  action :create
  recursive true
end

directory "#{node[:openstack][:bin]}" do
  action :create
  recursive true
end

directory "#{node[:openstack][:log]}" do
  action :create
  recursive true
end

cookbook_file "#{node[:openstack][:bin]}\\OpenStackService.exe" do
  source "OpenStackService.exe"
end

cookbook_file "#{node[:openstack][:bin]}\\mkisofs.exe" do
  source "mkisofs.exe"
end

cookbook_file "#{node[:openstack][:bin]}\\mkisofs_license.txt" do
  source "mkisofs_license.txt"
end

cookbook_file "#{node[:openstack][:bin]}\\qemu-img.exe" do
  source "qemu-img.exe"
end

template "#{node[:openstack][:config]}\\nova.conf" do
  source "nova.conf.erb"
  variables(
            :glance_server_protocol => glance_server_protocol,
            :glance_server_host => glance_server_host,
            :glance_server_port => glance_server_port,
            :glance_server_insecure => glance_server_insecure,
            :quantum_protocol => quantum_protocol,
            :quantum_server_host => quantum_server_host,
            :quantum_server_port => quantum_server_port,
            :quantum_insecure => quantum_insecure,
            :quantum_service_user => quantum_service_user,
            :quantum_service_password => quantum_service_password,
            :quantum_networking_plugin => quantum_networking_plugin,
            :keystone_service_tenant => keystone_service_tenant,
            :keystone_protocol => keystone_protocol,
            :keystone_host => keystone_host,
            :keystone_admin_port => keystone_admin_port,
            :cinder_insecure => cinder_insecure,
            :rabbit_settings => rabbit_settings,
            :instances_path => node[:openstack][:instances],
            :openstack_config => node[:openstack][:config],
            :openstack_bin => node[:openstack][:bin],
            :openstack_log => node[:openstack][:log]
           )
end

template "#{node[:openstack][:config]}\\quantum_hyperv_agent.conf" do
  source "quantum_hyperv_agent.conf.erb"
  variables(
            :rabbit_settings => rabbit_settings,
            :openstack_log => node[:openstack][:log]
           )
end

cookbook_file "#{node[:openstack][:config]}\\policy.json" do
  source "policy.json"
end

cookbook_file "#{node[:openstack][:config]}\\interfaces.template" do
  source "interfaces.template"
end

