raise if not node[:platform] == 'windows'

#Fetch and extract the packaged Python 2.7.5 archive
cookbook_file "#{node[:cache_location]}#{node[:python][:archive]}" do
  source node[:python][:archive]
  not_if {::File.exists?(node[:python][:archive])}
end

windows_batch "unzip_pymysql" do
  code <<-EOH
#{node[:sevenzip][:command]} x #{node[:cache_location]}#{node[:python][:archive]} -o#{node[:python][:path]} -r -y
EOH
  not_if {::File.exists?(node[:python][:installed])}
end