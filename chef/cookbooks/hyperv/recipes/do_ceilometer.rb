raise if not node[:platform] == 'windows'

include_recipe "hyperv::openstack_install_ceilometer"
include_recipe "hyperv::openstack_install_neutron"
include_recipe "hyperv::config_neutron"
include_recipe "hyperv::config_ceilometer"
include_recipe "hyperv::register_services_ceilometer"
include_recipe "hyperv::register_services_neutron"
