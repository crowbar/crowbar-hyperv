raise if not node[:platform] == 'windows'

#download Python Win32 from Chef server
cookbook_file "#{node[:cache_location]}#{node[:pycrypto][:file]}" do
  source node[:pycrypto][:file]
  not_if {::File.exists?(node[:pycrypto][:installed])}
end

windows_batch "unzip_pycrypto" do
  code <<-EOH
  #{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:pycrypto][:file]} -o#{node[:pycrypto][:target]} -r -y
  xcopy #{node[:pycrypto][:target]}\\PLATLIB #{node[:pycrypto][:target]} /e /y
  rmdir /S /Q  #{node[:pycrypto][:target]}\\PLATLIB
  EOH
  not_if {::File.exists?(node[:pycrypto][:installed])}
end

