raise if not node[:platform] == "windows"

powershell "register_services" do
  code <<-EOH
    if (-not (Get-Service "#{node[:service][:ceilometer][:name]}" -ErrorAction SilentlyContinue))
    {
      New-Service -name "#{node[:service][:ceilometer][:name]}" -binaryPathName "`"#{node[:openstack][:bin]}\\#{node[:service][:file]}`" ceilometer-compute-agent `"#{node[:openstack][:ceilometer][:installed]}`" --config-file `"#{node[:openstack][:config]}\\ceilometer.conf`"" -displayName "#{node[:service][:ceilometer][:displayname]}" -description "#{node[:service][:ceilometer][:description]}" -startupType Automatic
      Start-Service "#{node[:service][:ceilometer][:name]}"
      Set-Service -Name "#{node[:service][:ceilometer][:name]}" -StartupType Automatic
    }
  EOH
end

service "ceilometer-compute" do
  service_name node[:service][:ceilometer][:name]
  action [:enable, :start]
  subscribes :restart, "template[#{node[:openstack][:config].gsub(/\\/, "/")}/ceilometer.conf]"
end
