raise if not node[:platform] == 'windows'

#download Python Win32 from Chef server
cookbook_file "#{node[:cache_location]}#{node[:pywin32][:file]}" do
  source node[:pywin32][:file]
  not_if {::File.exists?(node[:pywin32][:installed])}
end

windows_batch "unzip_and_install_pywin32" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:pywin32][:file]}  -o#{node[:pywin32][:target]} -r -y
  xcopy #{node[:pywin32][:target]}\\PLATLIB #{node[:pywin32][:target]} /e /y
  xcopy #{node[:pywin32][:target]}\\SCRIPTS #{node[:pywin32][:target]} /e /y
  rmdir /S /Q  #{node[:pywin32][:target]}\\PLATLIB
  rmdir /S /Q  #{node[:pywin32][:target]}\\SCRIPTS
  #{node[:python][:command]} #{node[:pywin32][:installscript]} -install
  EOH
  not_if {::File.exists?(node[:pywin32][:installed])}
end
