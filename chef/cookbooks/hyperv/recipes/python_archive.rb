raise unless node[:platform_family] == "windows"

#Fetch and extract the packaged Python 2.7.5 archive
cookbook_file "#{node[:cache_location]}#{node[:python][:archive]}" do
  source node[:python][:archive]
  not_if { ::File.exist?(node[:python][:archive]) }
end

#Extract the packaged Python 2.7.5 archive
windows_batch "unzip_python275" do
  code <<-EOH
#{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:python][:archive]} -o#{node[:python][:path]} -r -y
EOH
  not_if { ::File.exist?(node[:python][:installed]) }
end

unless registry_value_exists?("HKEY_LOCAL_MACHINE\\SOFTWARE\\Crowbar", {name: "PyWin32Registered", type: :string, data: "PyWin32 Registered"}, :machine)
 #Register Python Win32 DLLs
 windows_batch "register_pywin32" do
   code <<-EOH
#{node[:python][:command]} #{node[:python][:scripts]}\\#{node[:python][:pywin32register]} -install
   EOH
 end
end

registry_key "HKEY_LOCAL_MACHINE\\SOFTWARE\\Crowbar" do
  values [{
    name: "PyWin32Registered",
    type: :string,
    data: "PyWin32 Registered"
  }]
  action :create_if_missing
end

