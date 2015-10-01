raise if not node[:platform_family] == "windows"

include_recipe "hyperv::windows_features"
include_recipe "hyperv::setup_networking"
include_recipe "hyperv::7zip"
include_recipe "hyperv::python"
include_recipe "hyperv::python_archive"
