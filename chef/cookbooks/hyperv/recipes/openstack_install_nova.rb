raise if not node[:platform_family] == "windows"

cookbook_file "#{node[:cache_location]}#{node[:openstack][:nova][:file]}" do
  source node[:openstack][:nova][:file]
  not_if { ::File.exists?(node[:openstack][:nova][:installed]) }
end

windows_batch "unzip_nova" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:nova][:file]} -o#{node[:openstack][:location]} -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:nova][:name]}-#{node[:openstack][:nova][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:nova][:name]}-#{node[:openstack][:nova][:version]} #{node[:openstack][:nova][:name]}
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
  not_if { ::File.exist?(node[:openstack][:nova][:installed]) }
end
