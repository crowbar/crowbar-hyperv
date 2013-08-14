raise if not node[:platform] == 'windows'

# install VexaSoft Cmdlet Library
windows_package "VexaSoftCmdletLibrary" do
  source node[:vexasoft][:url]
  installer_type :msi
  action :install
end
