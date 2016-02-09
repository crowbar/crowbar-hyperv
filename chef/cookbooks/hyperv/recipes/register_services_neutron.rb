raise unless node[:platform_family] == "windows"

powershell "register_services" do
  code <<-EOH
    if (-not (Get-Service "#{node[:service][:neutron][:name]}" -ErrorAction SilentlyContinue))
    {
      New-Service -name "#{node[:service][:neutron][:name]}" -binaryPathName "`"#{node[:openstack][:bin]}\\#{node[:service][:file]}`" neutron-hyperv-agent `"#{node[:openstack][:neutron][:binary]}`" --config-file `"#{node[:openstack][:neutron][:config]}\\neutron_hyperv_agent.conf`"" -displayName "#{node[:service][:neutron][:displayname]}" -description "#{node[:service][:neutron][:description]}" -startupType Automatic
      Start-Service "#{node[:service][:neutron][:name]}"
      Set-Service -Name "#{node[:service][:neutron][:name]}" -StartupType Automatic
    }
    Start-Service -Name MSiSCSI
    Set-Service -Name MSiSCSI -StartupType Automatic
  EOH
end

service "neutron-hyperv-agent" do
  service_name node[:service][:neutron][:name]
  action [:enable, :start]
  subscribes :restart, "template[#{node[:openstack][:neutron][:config].gsub(/\\/, "/")}/neutron_hyperv_agent.conf]"
end
