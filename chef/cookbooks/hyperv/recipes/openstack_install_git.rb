raise if not node[:platform] == 'windows'

node[:openstack][:git][:clients].each do |openstack_client|
  windows_batch "install_openstack_clients" do
    code <<-EOH
    #{node[:pip][:command]} install --upgrade #{openstack_client}
    EOH
   # not_if {::File.exists?(node[:pymysql][:installed])}
  end
end

git_clone node[:openstack][:git][:nova][:name] do
  opt node[:openstack][:git][:options]
end

git_clone node[:openstack][:git][:quantum][:name] do
  opt node[:openstack][:git][:options]
end
