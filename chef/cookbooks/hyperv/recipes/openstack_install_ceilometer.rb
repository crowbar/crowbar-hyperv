raise unless node[:platform_family] == "windows"

installed_file = "#{node[:openstack][:location]}\\installed-#{node[:openstack][:ceilometer][:name]}"
if File.exist? installed_file
  Chef::Log.info("#{node[:openstack][:ceilometer][:name]} files already installed")
  return
end

cached_file = "#{node[:cache_location]}#{node[:openstack][:ceilometer][:file]}"
cookbook_file cached_file do
  source node[:openstack][:ceilometer][:file]
end

windows_batch "unzip_ceilometer" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{cached_file]} -o#{node[:openstack][:location]} -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:ceilometer][:name]}-#{node[:openstack][:tarball_branch]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:ceilometer][:name]}-* #{node[:openstack][:ceilometer][:name]}
  EOH
  not_if { ::File.exist?("#{node[:openstack][:location]}\\#{node[:openstack][:ceilometer][:name]}") }
end

powershell "install_ceilometer" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:ceilometer][:name]}
  $env:PBR_VERSION=Get-Content setup.cfg | Select-String -Pattern "version = " | %{$_ -replace "version = ", ""}
  #{node[:python][:command]} setup.py install
  EOH
end

utils_line "ensure correct python path in shebang in ceilometer" do
  file "#{node[:python][:scripts]}\\#{node[:service][:ceilometer][:name]}-script.py"
  regexp /\A#!.*/
  replace "#! #{node[:python][:command]}"
  action :replace
end

file installed_file do
  action :create
end
