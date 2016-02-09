raise unless node[:platform_family] == "windows"

cookbook_file "#{node[:cache_location]}#{node[:openstack][:ceilometer][:file]}" do
  source node[:openstack][:ceilometer][:file]
  not_if { ::File.exist?(node[:openstack][:ceilometer][:installed]) }
end

windows_batch "unzip_ceilometer" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:ceilometer][:file]} -o#{node[:openstack][:location]} -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:ceilometer][:name]}-#{node[:openstack][:ceilometer][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:ceilometer][:name]}-#{node[:openstack][:ceilometer][:version]} #{node[:openstack][:ceilometer][:name]}
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
  not_if { ::File.exist?(node[:openstack][:ceilometer][:installed]) }
end

utils_line "ensure correct python path in shebang in ceilometer" do
  file "#{node[:python][:scripts]}\\#{node[:service][:ceilometer][:name]}-script.py"
  regexp /\A#!.*/
  replace "#! #{node[:python][:command]}"
  action :replace
end
