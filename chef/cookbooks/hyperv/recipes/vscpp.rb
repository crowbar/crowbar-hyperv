raise if not node[:platform] == 'windows'

# install Visual Studio C++ runtime libraries
# (both vscpp2010 and vscpp2012) 

windows_package "VisualStudioCPP2008" do
  source node[:vscpp][:"2008"][:url]
  options "/q /norestart"
  installer_type :installshield
  action :install
end

#windows_package "VisualStudioCPP2010" do
#  source node[:vscpp][:"2010"][:url]
#  options "/q /norestart"
#  installer_type :installshield
#  action :install
#end

#windows_package "VisualStudioCPP2012" do
#  source node[:vscpp][:"2012"][:url]
#  options "/q /norestart"
#  installer_type :installshield
#  action :install
#end

