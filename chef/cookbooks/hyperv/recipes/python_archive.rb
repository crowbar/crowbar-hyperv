raise if not node[:platform] == 'windows'

#Fetch and extract the packaged Python 2.7.5 archive
cookbook_file "#{node[:cache_location]}#{node[:python][:archive]}" do
  source node[:python][:archive]
  not_if {::File.exists?(node[:python][:archive])}
end

#Extract the packaged Python 2.7.5 archive
windows_batch "unzip_python275" do
  code <<-EOH
#{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:python][:archive]} -o#{node[:python][:path]} -r -y
EOH
  not_if {::File.exists?(node[:python][:installed])}
end

unless node[:python_win32_registered]
  #Register Python Win32 DLLs
  windows_batch "register_pywin32" do
    code <<-EOH
#{node[:python][:command]} #{node[:python][:scripts]}\\#{node[:python][:pywin32register]} -install
    EOH
  end
  node.set[:python_win32_registered] = true
  node.save
end

