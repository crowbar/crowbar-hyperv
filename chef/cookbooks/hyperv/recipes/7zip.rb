raise if not node[:platform] == 'windows'

cookbook_file "#{node[:cache_location]}#{node[:sevenzip][:file]}" do
  source node[:sevenzip][:file]
end

# install 7Zip
windows_package "7-Zip-9.22" do
  source "#{node[:cache_location]}#{node[:sevenzip][:file]}"
  installer_type :msi
  action :install
end
