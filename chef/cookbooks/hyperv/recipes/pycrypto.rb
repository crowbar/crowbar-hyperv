raise if not node[:platform] == 'windows'

#download Python Win32 from Chef server
remote_file node[:pycrypto][:location] do
  source node[:pycrypto][:url]
  not_if {::File.exists?(node[:pycrypto][:installed])}
end

windows_batch "unzip_pycrypto" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:pycrypto][:location]} -o#{node[:pycrypto][:target]} -r -y
  xcopy #{node[:pycrypto][:target]}\\PLATLIB #{node[:pycrypto][:target]} /e /y
  rmdir /S /Q  #{node[:pycrypto][:target]}\\PLATLIB
  EOH
  not_if {::File.exists?(node[:pycrypto][:installed])}
end

