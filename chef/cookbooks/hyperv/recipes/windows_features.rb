raise if not node[:platform] == 'windows'

node.default[:windows][:allow_pending_reboots] = false

if node[:target_platform] !~ /^hyperv/
  unless node[:windows_features_installed].is_a? Array
    node.set[:windows_features_installed] = []
    node.save
  end

  node[:features_list][:windows].each do |feature_name, feature_attrs|
    next if node[:windows_features_installed].include? feature_name

    windows_feature feature_name do
      action :install
      all feature_attrs["all"] || true
      restart feature_attrs["restart"] || false
    end

    ruby_block 'set_windows_features_install_flag' do
      block do
        node.set[:windows_features_installed].push feature_name
        node.save
      end
    end
  end
end

