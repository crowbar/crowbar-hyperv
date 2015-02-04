raise if not node[:platform] == 'windows'

include_recipe "hyperv::windows_features"
include_recipe "hyperv::setup_networking"
include_recipe "hyperv::7zip"
include_recipe "hyperv::python"
include_recipe "hyperv::python_archive"
include_recipe "hyperv::openstack_install"
include_recipe "hyperv::config"
include_recipe "hyperv::register_services"
