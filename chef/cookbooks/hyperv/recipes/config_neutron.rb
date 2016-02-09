raise unless node[:platform_family] == "windows"

keystone_settings = KeystoneHelper.keystone_settings(node, :nova)

neutron_servers = search(:node, "roles:neutron-server")
if neutron_servers.length > 0
  neutron_server = neutron_servers[0]
  neutron_server = node if neutron_server.name == node.name
  neutron_protocol = neutron_server[:neutron][:api][:protocol]
  neutron_server_host = CrowbarHelper.get_host_for_admin_url(neutron_server, (neutron_server[:neutron][:ha][:server][:enabled] rescue false))
  neutron_server_port = neutron_server[:neutron][:api][:service_port]
  neutron_insecure = neutron_protocol == "https" && neutron_server[:neutron][:ssl][:insecure]
  neutron_service_user = neutron_server[:neutron][:service_user]
  neutron_service_password = neutron_server[:neutron][:service_password]
  neutron_networking_plugin = neutron_server[:neutron][:networking_plugin]
  neutron_ml2_type_drivers = neutron_server[:neutron][:ml2_type_drivers]
else
  neutron_server_host = nil
  neutron_server_port = nil
  neutron_service_user = nil
  neutron_service_password = nil
  neutron_networking_plugin = "ml2"
  neutron_ml2_type_drivers = []
end
Chef::Log.info("Neutron server at #{neutron_server_host}")

vlan_start = node[:network][:networks][:nova_fixed][:vlan]
num_vlans = neutron_server[:neutron][:num_vlans]
vlan_end = [vlan_start + num_vlans - 1, 4094].min

# Chef 11.4 fails to notify if the path separator is windows like,
# according to https://tickets.opscode.com/browse/CHEF-4082 using gsub
# to replace the windows path separator to linux one
template "#{node[:openstack][:neutron][:config].gsub(/\\/, "/")}/neutron_hyperv_agent.conf" do
  source "neutron_hyperv_agent.conf.erb"
  variables(
            rabbit_settings: fetch_rabbitmq_settings("nova"),
            neutron_config: node[:openstack][:neutron][:config],
            openstack_log: node[:openstack][:log],
            neutron_networking_plugin: neutron_networking_plugin,
            neutron_ml2_type_drivers: neutron_ml2_type_drivers,
            vlan_start: vlan_start,
            vlan_end: vlan_end
           )
end

cookbook_file "#{node[:openstack][:config]}/interfaces.template" do
  source "interfaces.template"
end

