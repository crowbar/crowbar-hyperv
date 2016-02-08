raise unless node[:platform_family] == "windows"

powershell "register_services" do
  code <<-EOH
    if (-not (Get-Service "#{node[:service][:ceilometer][:name]}" -ErrorAction SilentlyContinue))
    {
      New-Service -name "#{node[:service][:ceilometer][:name]}" -binaryPathName "`"#{node[:openstack][:bin]}\\#{node[:service][:file]}`" ceilometer-agent-compute `"#{node[:openstack][:ceilometer][:binary]}`" --config-file `"#{node[:openstack][:ceilometer][:config]}\\ceilometer.conf`"" -displayName "#{node[:service][:ceilometer][:displayname]}" -description "#{node[:service][:ceilometer][:description]}" -startupType Automatic
      Start-Service "#{node[:service][:ceilometer][:name]}"
      Set-Service -Name "#{node[:service][:ceilometer][:name]}" -StartupType Automatic
    }
  EOH
end

service "ceilometer-agent-compute" do
  service_name node[:service][:ceilometer][:name]
  action [:enable, :start]
  subscribes :restart, "template[#{node[:openstack][:ceilometer][:config].gsub(/\\/, "/")}/ceilometer.conf]"
end
