raise if not node[:platform] == 'windows'

# install Python 2.7.3
windows_package "Python 2.7.3" do
  source node[:python][:file]
  installer_type :msi
  action :install
end

windows_path node[:python][:path] do
  action :add
end

