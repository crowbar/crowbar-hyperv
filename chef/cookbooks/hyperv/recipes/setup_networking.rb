raise unless node[:platform_family] == "windows"

admin_net = Barclamp::Inventory.get_network_by_type(node, "admin")

powershell "configure_networking" do
  code <<-EOH
  Rename-NetAdapter -Name (Get-NetIPAddress -IPAddress "#{admin_net.address}").InterfaceAlias -NewName "Management"
  $VSwitchList = Get-VMSwitch
  $SwitchConfigured = $false

  if ($VSwitchList -ne $null)
  {
    foreach ($VSwitch in $VSwitchList)
    {
      if ($VSwitch.Name -eq "vswitch") {$SwitchConfigured = $true}
    }
  }
  if ($SwitchConfigured -ne $true)
  {
    $NetAdapterList = Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and $_.Name -ne "Management" -and $_.Virtual -ne "True"} | Select Name
    $i=0
    foreach ($NetCard in $NetAdapterList)
    {
      Rename-NetAdapter -Name $NetCard.Name -NewName "VSwitchNetCard$i"
      $i++
    }
    if ($i -gt 0)
    {
      New-VMSwitch -NetAdapterName "VSwitchNetCard0" -Name "vswitch" -AllowManagementOS $false
    } else {
      New-VMSwitch -NetAdapterName "Management" -Name "vswitch" -AllowManagementOS $true
    }
  }
  EOH
end
