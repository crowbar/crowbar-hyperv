raise if not node[:platform_family] == "windows"

include_recipe "hyperv::openstack_install_neutron"
include_recipe "hyperv::openstack_install_nova"
include_recipe "hyperv::config_common_openstack"
include_recipe "hyperv::config_neutron"
include_recipe "hyperv::config_nova"
include_recipe "hyperv::register_services_neutron"
include_recipe "hyperv::register_services_nova"
