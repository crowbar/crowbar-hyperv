raise if not node[:platform] == 'windows'

service "w32time" do
  action :stop
end

execute "update_timezone" do
  command "tzutil.exe /S \"#{node[:time][:zone]}\""
end

execute "update_timezone" do
  command "w32tm.exe /config /manualpeerlist:\#{node[:time][:server]},0x8 /syncfromflags:MANUAL"
end

execute "update_timezone" do
  command "w32tm.exe /config /update"
end

service "w32time" do
  action :start
end
