raise if not node[:platform] == 'windows'

#download Greenlet Exec from URL
remote_file node[:greenlet][:location] do
  source node[:greenlet][:url]
  not_if {::File.exists?(node[:greenlet][:installed])}
end

windows_batch "unzip_greenlet" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:greenlet][:location]} -o#{node[:greenlet][:target]} -r -y
  xcopy #{node[:greenlet][:target]}\\PLATLIB #{node[:greenlet][:target]} /e /y
  xcopy #{node[:greenlet][:target]}\\HEADERS\\Include\\greenlet #{node[:greenlet][:target]} /e /y
  rmdir /S /Q  #{node[:greenlet][:target]}\\PLATLIB
  rmdir /S /Q  #{node[:greenlet][:target]}\\HEADERS
  EOH
  not_if {::File.exists?(node[:greenlet][:installed])}
end
