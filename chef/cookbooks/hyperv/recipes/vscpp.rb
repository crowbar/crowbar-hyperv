raise if not node[:platform] == 'windows'

# install Visual Studio C++ runtime libraries

windows_package "VisualStudioCPP2008" do
  source node[:vscpp][:"2008"][:file]
  options "/q /norestart"
  installer_type :installshield
  action :install
end
