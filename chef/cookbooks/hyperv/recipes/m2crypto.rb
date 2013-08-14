raise if not node[:platform] == 'windows'

# install Python 2.7.3
windows_package "Python M2Crypto" do
  source node[:m2crypto][:url]
  installer_type :msi
  action :install
end

