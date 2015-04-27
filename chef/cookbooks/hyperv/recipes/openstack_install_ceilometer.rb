raise if not node[:platform] == 'windows'

#node[:openstack][:git][:clients].each do |openstack_client|
#  windows_batch "install_openstack_clients" do
#    code <<-EOH
#    #{node[:pip][:command]} install --upgrade #{openstack_client}
#    EOH
#   # not_if {::File.exists?(node[:pymysql][:installed])}
#  end
#end


cookbook_file "#{node[:cache_location]}#{node[:openstack][:ceilometer][:file]}" do
  source node[:openstack][:ceilometer][:file]
  not_if {::File.exists?(node[:openstack][:ceilometer][:installed])}
end

windows_batch "unzip_ceilometer" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:ceilometer][:file]} -o#{node[:openstack][:location]}\\dist -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:ceilometer][:name]}-#{node[:openstack][:ceilometer][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:ceilometer][:name]}-#{node[:openstack][:ceilometer][:version]} #{node[:openstack][:ceilometer][:name]}
  EOH
  not_if {::File.exists?("#{node[:openstack][:location]}\\#{node[:openstack][:ceilometer][:name]}")}
end

windows_batch "install_ceilometer" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:ceilometer][:name]}
  #{node[:python][:command]} setup.py install --force
  EOH
  not_if {::File.exists?("#{node[:openstack][:ceilometer][:installed]}")}
end
