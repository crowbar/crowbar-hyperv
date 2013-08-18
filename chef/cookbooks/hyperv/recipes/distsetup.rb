raise if not node[:platform] == 'windows'

#Fetch and install Python DistributeSetup Installer
cookbook_file "#{node[:cache_location]}#{node[:distsetup][:file]}" do
  source node[:distsetup][:file]
  not_if {::File.exists?(node[:distsetup][:installed])}
end

windows_batch "install_distsetup" do
  code <<-EOH
  #{node[:python][:command]} #{node[:cache_location][:location]}#{node[:distsetup][:file]}
  EOH
  not_if {::File.exists?(node[:distsetup][:installed])}
end
