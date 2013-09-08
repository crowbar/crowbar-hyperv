raise if not node[:platform] == 'windows'

#node[:openstack][:git][:clients].each do |openstack_client|
#  windows_batch "install_openstack_clients" do
#    code <<-EOH
#    #{node[:pip][:command]} install --upgrade #{openstack_client}
#    EOH
#   # not_if {::File.exists?(node[:pymysql][:installed])}
#  end
#end


cookbook_file "#{node[:cache_location]}#{node[:openstack][:nova][:file]}" do
  source node[:openstack][:nova][:file]
  not_if {::File.exists?(node[:openstack][:nova][:installed])}
end

windows_batch "unzip_nova" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:nova][:file]} -o#{node[:openstack][:location]}\\dist -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:nova][:name]}-#{node[:openstack][:nova][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:nova][:name]}-#{node[:openstack][:nova][:version]} #{node[:openstack][:nova][:name]}
  EOH
  not_if {::File.exists?("#{node[:openstack][:location]}\\#{node[:openstack][:nova][:name]}")}
end

windows_batch "install_nova" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:nova][:name]}
  #{node[:python][:command]} setup.py install --force
  EOH
  not_if {::File.exists?("#{node[:openstack][:nova][:installed]}")}
end

cookbook_file "#{node[:cache_location]}#{node[:openstack][:quantum][:file]}" do
  source node[:openstack][:quantum][:file]
  not_if {::File.exists?(node[:openstack][:quantum][:installed])}
end

windows_batch "unzip_quantum" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:openstack][:quantum][:file]} -o#{node[:openstack][:location]}\\dist -r -y
  #{node[:sevenzip][:command]} x #{node[:openstack][:location]}\\dist\\#{node[:openstack][:quantum][:name]}-#{node[:openstack][:quantum][:version]}.tar -o#{node[:openstack][:location]} -r -y
  rmdir /S /Q #{node[:openstack][:location]}\\dist
  ren #{node[:openstack][:location]}\\#{node[:openstack][:quantum][:name]}-#{node[:openstack][:quantum][:version]} #{node[:openstack][:quantum][:name]}
  EOH
  not_if {::File.exists?("#{node[:openstack][:location]}\\#{node[:openstack][:quantum][:name]}")}
end

windows_batch "install_quantum" do
  code <<-EOH
  cd #{node[:openstack][:location]}
  cd #{node[:openstack][:quantum][:name]}
  #{node[:python][:command]} setup.py install --force
  EOH
  # not_if {::File.exists?("#{node[:openstack][:quantum][:installed]}")}
end

