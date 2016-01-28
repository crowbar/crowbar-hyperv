raise unless node[:platform_family] == "windows"

installed_file = "#{node[:openstack][:location]}\\installed-#{node[:openstack][:nova][:name]}"
if File.exist? installed_file
  Chef::Log.info("#{node[:openstack][:nova][:name]} files already installed")
  return
end

cached_file = "#{node[:cache_location]}#{node[:openstack][:nova][:file]}" do
cookbook_file cached_file do
  source node[:openstack][:nova][:file]
end

windows_batch "unzip_nova" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{cached_file} -o#{node[:openstack][:location]} -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:nova][:name]}-#{node[:openstack][:tarball_branch]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:nova][:name]}-* #{node[:openstack][:nova][:name]}
  EOH
  not_if { ::File.exist?("#{node[:openstack][:location]}\\#{node[:openstack][:nova][:name]}") }
end

powershell "install_nova" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:nova][:name]}
  $env:PBR_VERSION=Get-Content setup.cfg | Select-String -Pattern "version = " | %{$_ -replace "version = ", ""}
  #{node[:python][:command]} setup.py install
  EOH
end

utils_line "ensure correct python path in shebang in nova" do
  file "#{node[:python][:scripts]}\\#{node[:service][:nova][:name]}-script.py"
  regexp /\A#!.*/
  replace "#! #{node[:python][:command]}"
  action :replace
end

file installed_file do
  action :create
end
