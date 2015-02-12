raise if not node[:platform] == 'windows'

include_recipe 'windows::reboot_handler'
node.default[:windows][:allow_pending_reboots] = false

if node[:target_platform] =~ /^hyperv/
  unless node[:windows_features_installed]
    node.set[:windows_features_installed] = true
    node.save
  end
end

if !node[:windows_features_installed]

  node[:features_list][:windows].each do |feature_list|
    windows_feature feature_list do
      action :install
      all true
    end
  end

  ruby_block 'set_windows_features_install_flag' do
    block do
      node.set[:windows_features_installed] = true
      node.save
    end
  end

  windows_reboot 60 do
    reason 'Installing required Windows features requires a reboot'
    action :request
  end

end

