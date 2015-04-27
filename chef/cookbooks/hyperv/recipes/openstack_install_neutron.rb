raise if not node[:platform] == 'windows'

cookbook_file "#{node[:cache_location]}#{node[:openstack][:neutron][:file]}" do
  source node[:openstack][:neutron][:file]
  not_if {::File.exists?(node[:openstack][:neutron][:installed])}
end

windows_batch "unzip_neutron" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:neutron][:file]} -o#{node[:openstack][:location]}\\dist -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:neutron][:name]}-#{node[:openstack][:neutron][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:neutron][:name]}-#{node[:openstack][:neutron][:version]} #{node[:openstack][:neutron][:name]}
  EOH
  not_if {::File.exists?("#{node[:openstack][:location]}\\#{node[:openstack][:neutron][:name]}")}
end

windows_batch "install_neutron" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:neutron][:name]}
  #{node[:python][:command]} setup.py install --force
  EOH
  not_if {::File.exists?("#{node[:openstack][:neutron][:installed]}")}
end

