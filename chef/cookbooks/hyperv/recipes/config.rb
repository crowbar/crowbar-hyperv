raise if not node[:platform] == 'windows'

glance_servers = search(:node, "roles:glance-server")
if glance_servers.length > 0
  glance_server = glance_servers[0]
  glance_server = node if glance_server.name == node.name
  glance_server_host = CrowbarHelper.get_host_for_admin_url(glance_server, (glance_server[:glance][:ha][:enabled] rescue false))
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

keystone_settings = KeystoneHelper.keystone_settings(node, :nova)

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
  neutron_server_host = CrowbarHelper.get_host_for_admin_url(neutron_server, (neutron_server[:neutron][:ha][:server][:enabled] rescue false))
  neutron_server_port = neutron_server[:neutron][:api][:service_port]
  neutron_insecure = neutron_protocol == 'https' && neutron_server[:neutron][:ssl][:insecure]
  neutron_service_user = neutron_server[:neutron][:service_user]
  neutron_service_password = neutron_server[:neutron][:service_password]
  neutron_networking_mode = neutron_server[:neutron][:networking_mode]
  neutron_networking_plugin = neutron_server[:neutron][:networking_plugin]
else
  neutron_server_host = nil
  neutron_server_port = nil
  neutron_service_user = nil
  neutron_service_password = nil
  neutron_networking_mode = "local"
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
            :keystone_settings => keystone_settings,
            :cinder_insecure => cinder_insecure,
            :rabbit_settings => fetch_rabbitmq_settings("nova"),
            :instances_path => node[:openstack][:instances],
            :openstack_location => node[:openstack][:location],
            :openstack_config => node[:openstack][:config],
            :openstack_bin => node[:openstack][:bin],
            :openstack_log => node[:openstack][:log]
           )
end

vlan_start = node[:network][:networks][:nova_fixed][:vlan]
num_vlans = neutron_server[:neutron][:num_vlans]
vlan_end = [vlan_start + num_vlans - 1, 4094].min

template "#{node[:openstack][:config]}\\neutron_hyperv_agent.conf" do
  source "neutron_hyperv_agent.conf.erb"
  variables(
            :rabbit_settings => fetch_rabbitmq_settings("nova"),
            :openstack_location => node[:openstack][:location],
            :openstack_log => node[:openstack][:log],
            :networking_mode => neutron_networking_mode,
            :vlan_start => vlan_start,
            :vlan_end => vlan_end
           )
end

cookbook_file "#{node[:openstack][:config]}\\interfaces.template" do
  source "interfaces.template"
end

