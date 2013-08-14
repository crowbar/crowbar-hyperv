raise if not node[:platform] == 'windows'

# install Git
windows_package "Git" do
  source node[:git][:url]
#  installer_type :msi
  options "/silent"
  not_if {::File.exists?(node[:git][:command])}
  action :install
end

