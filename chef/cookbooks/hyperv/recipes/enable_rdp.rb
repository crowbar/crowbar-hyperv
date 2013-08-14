raise if not node[:platform] == 'windows'


powershell "enable_rdp" do
  command "powershell.exe -executionpolicy remotesigned -Command (Get-WmiObject win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTSConnections(1)"
end

powershell "enable_rdp_older_clients" do
  command "powershell.exe -executionpolicy remotesigned -Command Set-RemoteDesktopConfig -Enable -AllowOlderClients"
end
