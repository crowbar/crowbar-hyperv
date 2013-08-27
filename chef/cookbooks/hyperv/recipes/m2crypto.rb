raise if not node[:platform] == 'windows'

# install Python M2Crypto

cookbook_file "#{node[:cache_location]}#{node[:m2crypto][:file]}" do
  source node[:m2crypto][:file]
end

windows_package "Python M2Crypto" do
  source "#{node[:cache_location]}#{node[:m2crypto][:file]}"
  installer_type :msi
  action :install
end

