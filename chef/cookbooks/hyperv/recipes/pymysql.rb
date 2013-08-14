raise if not node[:platform] == 'windows'

#download Python Win32 from Chef server
remote_file node[:pymysql][:location] do
  source node[:pymysql][:url]
  not_if {::File.exists?(node[:pymysql][:installed])}
end

windows_batch "unzip_pymysql" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:pymysql][:location]} -o#{node[:pymysql][:target]} -r -y
  xcopy #{node[:pymysql][:target]}\\PLATLIB #{node[:pymysql][:target]} /e /y
  rmdir /S /Q  #{node[:pymysql][:target]}\\PLATLIB
  EOH
  not_if {::File.exists?(node[:pymysql][:installed])}
end
