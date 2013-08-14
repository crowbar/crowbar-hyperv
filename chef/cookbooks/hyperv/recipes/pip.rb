raise if not node[:platform] == 'windows'

windows_batch "install_pip" do
  code <<-EOH
  #{node[:easyinstall][:command]} pip
  EOH
  not_if {::File.exists?(node[:pip][:command])}
end

