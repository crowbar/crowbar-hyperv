raise if not node[:platform] == 'windows'

node[:features_list][:windows].each do |feature_list|
  windows_feature feature_list do
    action :install
  end
  notifies 'windows_reboot[60]'
end
