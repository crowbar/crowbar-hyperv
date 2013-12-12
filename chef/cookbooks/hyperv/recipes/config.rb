raise if not node[:platform] == 'windows'

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

keystones = search(:node, "recipes:keystone\\:\\:server")
if keystones.length > 0
  keystone = keystones[0]
  keystone = node if keystone.name == node.name
else
  keystone = node
end

keystone_host = keystone[:fqdn]
keystone_protocol = keystone["keystone"]["api"]["protocol"]
keystone_admin_port = keystone["keystone"]["api"]["admin_port"]
keystone_service_tenant = keystone["keystone"]["service"]["tenant"]
Chef::Log.info("Keystone server found at #{keystone_host}")

cinder_servers = search(:node, "roles:cinder-controller") || []
if cinder_servers.length > 0
  cinder_server = cinder_servers[0]
  cinder_insecure = cinder_server[:cinder][:api][:protocol] == 'https' && cinder_server[:cinder][:ssl][:insecure]
else
  cinder_insecure = false
end

neutron_servers = search(:node, "roles:neutron-server")
if neutron_servers.length > 0
  neutron_server = neutron_servers[0]
  neutron_server = node if neutron_server.name == node.name
  neutron_protocol = neutron_server[:neutron][:api][:protocol]
  neutron_server_host = neutron_server[:fqdn]
  neutron_server_port = neutron_server[:neutron][:api][:service_port]
  neutron_insecure = neutron_protocol == 'https' && neutron_server[:neutron][:ssl][:insecure]
  neutron_service_user = neutron_server[:neutron][:service_user]
  neutron_service_password = neutron_server[:neutron][:service_password]
  if neutron_server[:neutron][:networking_mode] != 'local'
    per_tenant_vlan=true
  else
    per_tenant_vlan=false
  end
  neutron_networking_plugin = neutron_server[:neutron][:networking_plugin]
  neutron_networking_mode = neutron_server[:neutron][:networking_mode]
else
  neutron_server_host = nil
  neutron_server_port = nil
  neutron_service_user = nil
  neutron_service_password = nil
end
Chef::Log.info("Neutron server at #{neutron_server_host}")

dirs = [ node[:openstack][:instances], node[:openstack][:config], node[:openstack][:bin], node[:openstack][:log] ]
dirs.each do |dir|
  directory dir do
    action :create
    recursive true
  end
end

%w{ OpenStackService.exe mkisofs.exe mkisofs_license.txt qemu-img.exe intl.dll libglib-2.0-0.dll libssp-0.dll zlib1.dll }.each do |bin_file|
  cookbook_file "#{node[:openstack][:bin]}\\#{bin_file}" do
    source bin_file
  end
end

template "#{node[:openstack][:config]}\\nova.conf" do
  source "nova.conf.erb"
  variables(
            :glance_server_protocol => glance_server_protocol,
            :glance_server_host => glance_server_host,
            :glance_server_port => glance_server_port,
            :glance_server_insecure => glance_server_insecure,
            :neutron_protocol => neutron_protocol,
            :neutron_server_host => neutron_server_host,
            :neutron_server_port => neutron_server_port,
            :neutron_insecure => neutron_insecure,
            :neutron_service_user => neutron_service_user,
            :neutron_service_password => neutron_service_password,
            :neutron_networking_plugin => neutron_networking_plugin,
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

template "#{node[:openstack][:config]}\\neutron_hyperv_agent.conf" do
  source "neutron_hyperv_agent.conf.erb"
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

