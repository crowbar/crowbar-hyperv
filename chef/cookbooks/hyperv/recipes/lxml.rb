raise if not node[:platform] == 'windows'

windows_batch "install_lxml" do
  code <<-EOH
  #{node[:easyinstall][:command]} lxml==2.3
  EOH
  not_if {::File.exists?("#{node[:python][:sitepackages]}\\lxml-2.3-py2.7-win32.egg")}
end

