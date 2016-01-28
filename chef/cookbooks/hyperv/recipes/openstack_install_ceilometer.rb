raise unless node[:platform_family] == "windows"

component = node[:openstack][:ceilometer][:name]
service = node[:service][:ceilometer][:name]

installed_file = "#{node[:openstack][:location]}\\installed-#{component}"
if File.exist? installed_file
  Chef::Log.info("#{component} files already installed")
  return
end

tarball = "#{component}-#{node[:openstack][:tarball_branch]}.tar.gz"
cached_file = "#{node[:cache_location]}#{tarball}"
cookbook_file cached_file do
  source tarball
end

windows_batch "unzip #{component}" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{cached_file} -o#{node[:openstack][:location]} -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{component}-#{node[:openstack][:tarball_branch]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{component}-* #{component}
  EOH
  not_if { ::File.exist?("#{node[:openstack][:location]}\\#{component}") }
end

powershell "install #{component}" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{component}
  $env:PBR_VERSION=Get-Content setup.cfg | Select-String -Pattern "version = " | %{$_ -replace "version = ", ""}
  #{node[:python][:command]} setup.py install
  EOH
end

utils_line "ensure correct python path in shebang in #{component}" do
  file "#{node[:python][:scripts]}\\#{service}-script.py"
  regexp /\A#!.*/
  replace "#! #{node[:python][:command]}"
  action :replace
end

file installed_file do
  action :create
end
