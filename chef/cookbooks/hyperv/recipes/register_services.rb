raise if not node[:platform] == 'windows'

powershell "register_services" do
  code <<-EOH
    if (-not (Get-Service "#{node[:service][:nova][:name]}" -ErrorAction SilentlyContinue))
    {
      # $secpasswd = ConvertTo-SecureString "crowbar" -AsPlainText -Force
      # $credentials = New-Object System.Management.Automation.PSCredential (".\\Administrator", $secpasswd)
      New-Service -name "#{node[:service][:nova][:name]}" -binaryPathName "`"#{node[:openstack][:bin]}\\#{node[:service][:file]}`" nova-compute `"#{node[:python][:command]}`" `"#{node[:openstack][:nova][:installed]}`" --config-file `"#{node[:openstack][:config]}\\nova.conf`"" -displayName "#{node[:service][:nova][:displayname]}" -description "#{node[:service][:nova][:description]}" -startupType Automatic
      # -Credential $credentials
      Start-Service "#{node[:service][:nova][:name]}"
    }
    if (-not (Get-Service "#{node[:service][:neutron][:name]}" -ErrorAction SilentlyContinue))
    {
      # $secpasswd = ConvertTo-SecureString "crowbar" -AsPlainText -Force
      # $credentials = New-Object System.Management.Automation.PSCredential (".\\Administrator", $secpasswd)
      New-Service -name "#{node[:service][:neutron][:name]}" -binaryPathName "`"#{node[:openstack][:bin]}\\#{node[:service][:file]}`" neutron-hyperv-agent `"#{node[:openstack][:neutron][:installed]}`" --config-file `"#{node[:openstack][:config]}\\neutron_hyperv_agent.conf`"" -displayName "#{node[:service][:neutron][:displayname]}" -description "#{node[:service][:neutron][:description]}" -startupType Automatic
      # -Credential $credentials
      Start-Service "#{node[:service][:neutron][:name]}"
    }
  EOH
end

