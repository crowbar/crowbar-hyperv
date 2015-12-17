raise unless node[:platform_family] == "windows"

cookbook_file "#{node[:cache_location]}#{node[:openstack][:networking_hyperv][:file]}" do
  source node[:openstack][:networking_hyperv][:file]
  not_if { ::File.exist?(node[:openstack][:networking_hyperv][:file]) }
end

windows_batch "unzip_networking-hyperv" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:networking_hyperv][:file]} -o#{node[:openstack][:location]} -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:networking_hyperv][:name]}-#{node[:openstack][:networking_hyperv][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:networking_hyperv][:name]}-#{node[:openstack][:networking_hyperv][:version]} #{node[:openstack][:networking_hyperv][:name]}
  EOH
  not_if { ::File.exist?("#{node[:openstack][:location]}\\#{node[:openstack][:networking_hyperv][:name]}") }
end

powershell "install_networking_hyperv" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:networking_hyperv][:name]}
  $env:PBR_VERSION=Get-Content setup.cfg | Select-String -Pattern "version = " | %{$_ -replace "version = ", ""}
  #{node[:python][:command]} setup.py install
  EOH
  not_if { ::File.exist?("#{node[:openstack][:networking_hyperv][:installed]}") }
end
