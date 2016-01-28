raise unless node[:platform_family] == "windows"

# install Python 2.7.5

cookbook_file "#{node[:cache_location]}#{node[:python][:file]}" do
  source node[:python][:file]
end

windows_package "Python 2.7.5" do
  source "#{node[:cache_location]}#{node[:python][:file]}"
  installer_type :msi
  action :install
end

windows_path node[:python][:path] do
  action :add
end

