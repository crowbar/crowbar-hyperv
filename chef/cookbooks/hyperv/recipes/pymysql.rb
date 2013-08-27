raise if not node[:platform] == 'windows'

#Fetch and install Python Win32 from Chef server
cookbook_file "#{node[:cache_location]}#{node[:pymysql][:file]}" do
  source node[:pymysql][:file]
  not_if {::File.exists?(node[:pymysql][:installed])}
end

windows_batch "unzip_pymysql" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:pymysql][:file]} -o#{node[:pymysql][:target]} -r -y
  xcopy #{node[:pymysql][:target]}\\PLATLIB #{node[:pymysql][:target]} /e /y
  rmdir /S /Q  #{node[:pymysql][:target]}\\PLATLIB
  EOH
  not_if {::File.exists?(node[:pymysql][:installed])}
end
