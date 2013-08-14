raise if not node[:platform] == 'windows'

#download Python DistributeSetup Installer
remote_file node[:distsetup][:location] do
  source node[:distsetup][:url]
  not_if {::File.exists?(node[:distsetup][:installed])}
end

windows_batch "install_distsetup" do
  code <<-EOH
  #{node[:python][:command]} #{node[:distsetup][:location]}
  EOH
  not_if {::File.exists?(node[:distsetup][:installed])}
end
