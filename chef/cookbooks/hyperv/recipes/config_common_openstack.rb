raise if not node[:platform] == "windows"

# Create common directories
dirs = [node[:openstack][:instances], node[:openstack][:config], node[:openstack][:bin], node[:openstack][:log]]
dirs.each do |dir|
  directory dir do
    action :create
    recursive true
  end
end

# Install executables
%w{ OpenStackService.exe }.each do |bin_file|
  cookbook_file "#{node[:openstack][:bin]}/#{bin_file}" do
    source bin_file
  end
end
