raise if not node[:platform] == 'windows'


powershell "configure_networking" do
  code <<-EOH
  Rename-NetAdapter -Name (Get-NetIPAddress -IPAddress "#{node[:crowbar][:network][:admin][:address]}").InterfaceAlias -NewName "Management"
  $network_cards = Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and $_.Name -ne "Management"} | Select Name
  $i=0
  foreach ($netcard in $network_cards)
  {
    Rename-NetAdapter -Name $netcard.Name -NewName "VSwitchNetCard$i"
    $i++
  }
  New-VMSwitch -NetAdapterName "VSwitchNetCard0" -Name "VSwitch" -AllowManagementOS $true
  EOH
end
