raise unless node[:platform_family] == "windows"

component = node[:openstack][:networking_hyperv][:name]

installed_file = "#{node[:openstack][:src]}\\installed-#{component}"
if File.exist? installed_file
  Chef::Log.info("#{component} files already installed")
  return
end

tarball = "#{component}-#{node[:openstack][:tarball_branch]}.tar.gz"
cached_file = "#{node[:cache_location]}#{tarball}"
cookbook_file cached_file do
  source tarball
end

# for loop is just a hack to make it possible to rename a file with a wildcard
windows_batch "unzip #{component}" do
  code <<-EOH
  rmdir /S /Q #{node[:openstack][:src]}\\#{component}
  #{node[:sevenzip][:command]} x #{cached_file} -so -y | #{node[:sevenzip][:command]} x -ttar -si -y -o#{node[:openstack][:src]}
  for /D %%f in (#{node[:openstack][:src]}\\#{component}-*) do ren "%%f" #{component}
  EOH
end

powershell "install #{component}" do
  code <<-EOH
  cd #{node[:openstack][:src]}
  cd #{component}
  $env:PBR_VERSION=Get-Content setup.cfg | Select-String -Pattern "version = " | %{$_ -replace "version = ", ""}
  #{node[:python][:command]} setup.py install
  EOH
end

file installed_file do
  action :create
end
