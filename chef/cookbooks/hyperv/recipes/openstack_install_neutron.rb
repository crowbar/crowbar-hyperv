raise unless node[:platform_family] == "windows"

cookbook_file "#{node[:cache_location]}#{node[:openstack][:neutron][:file]}" do
  source node[:openstack][:neutron][:file]
  not_if { ::File.exist?(node[:openstack][:neutron][:installed]) }
end

windows_batch "unzip_neutron" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:neutron][:file]} -o#{node[:openstack][:location]} -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:neutron][:name]}-#{node[:openstack][:neutron][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:neutron][:name]}-#{node[:openstack][:neutron][:version]} #{node[:openstack][:neutron][:name]}
  EOH
  not_if { ::File.exist?("#{node[:openstack][:location]}\\#{node[:openstack][:neutron][:name]}") }
end

powershell "install_neutron" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:neutron][:name]}
  $env:PBR_VERSION=Get-Content setup.cfg | Select-String -Pattern "version = " | %{$_ -replace "version = ", ""}
  #{node[:python][:command]} setup.py install
  EOH
  not_if { ::File.exist?(node[:openstack][:neutron][:installed]) }
end

utils_line "ensure correct python path in shebang in neutron" do
  file "#{node[:python][:scripts]}\\#{node[:service][:neutron][:name]}-script.py"
  regexp /\A#!.*/
  replace "#! #{node[:python][:command]}"
  action :replace
end
