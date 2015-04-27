raise if not node[:platform] == 'windows'

keystone_settings = KeystoneHelper.keystone_settings(node, :ceilometer)

bind_host = node[:ceilometer][:api][:host]
bind_port = node[:ceilometer][:api][:port]

if node[:ceilometer][:use_mongodb]
  db_connection = nil

  if node[:ceilometer][:ha][:server][:enabled]
    db_hosts = search(:node,
      "ceilometer_ha_mongodb_replica_set_member:true AND roles:ceilometer-server AND "\
      "ceilometer_config_environment:#{node[:ceilometer][:config][:environment]}"
      )
    unless db_hosts.empty?
      ## This will fail on windows, we need to find something better here
      mongodb_servers = db_hosts.map {|s| "#{Chef::Recipe::Barclamp::Inventory.get_network_by_type(s, "admin").address}:#{s[:ceilometer][:mongodb][:port]}"}
      db_connection = "mongodb://#{mongodb_servers.sort.join(',')}/ceilometer?replicaSet=#{node[:ceilometer][:ha][:mongodb][:replica_set][:name]}"
#    end
  end

  # if this is a cluster, but the replica set member attribute hasn't
  # been set on any node (yet), we just fallback to using the first
  # ceilometer-server node
  if db_connection.nil?
    db_hosts = search_env_filtered(:node, "roles:ceilometer-server")
    db_host = db_hosts.first || node
    ## This will fail on windows
    mongodb_ip = Chef::Recipe::Barclamp::Inventory.get_network_by_type(db_host, "admin").address
    db_connection = "mongodb://#{mongodb_ip}:#{db_host[:ceilometer][:mongodb][:port]}/ceilometer"
  end
else
  db_settings = fetch_database_settings

  include_recipe "database::client"
  include_recipe "#{db_settings[:backend_name]}::client"
  include_recipe "#{db_settings[:backend_name]}::python-client"

  db_password = ''
  if node.roles.include? "ceilometer-server"
    # password is already created because common recipe comes
    # after the server recipe
    db_password = node[:ceilometer][:db][:password]
  else
    # pickup password to database from ceilometer-server node
    node_controllers = search(:node, "roles:ceilometer-server") || []
    if node_controllers.length > 0
      db_password = node_controllers[0][:ceilometer][:db][:password]
    end
  end

  db_connection = "#{db_settings[:url_scheme]}://#{node[:ceilometer][:db][:user]}:#{db_password}@#{db_settings[:address]}/#{node[:ceilometer][:db][:database]}"
end


time_to_live = node[:ceilometer][:database][:time_to_live]
if time_to_live > 0
  # We store the value of time to live in days, but config file expects seconds
  time_to_live = time_to_live * 3600 * 24
end

is_compute_agent = node.roles.include?("ceilometer-agent") && node.roles.any?{|role| /^nova-multi-compute-/ =~ role}

dirs = [ node[:openstack][:ceilometer][:lock_path], node[:openstack][:ceilometer][:log_dir], node[:openstack][:ceilometer][:signing_dir] ]
dirs.each do |dir|
  directory dir do
    action :create
    recursive true
  end
end

template "#{node[:openstack][:config].gsub(/\\/, "/")}/ceilometer.conf" do
    source "ceilometer.conf.erb"
    variables(
      :debug => node[:ceilometer][:debug],
      :verbose => node[:ceilometer][:verbose],
      :rabbit_settings => fetch_rabbitmq_settings("ceilometer"),
      :keystone_settings => keystone_settings,
      :bind_host => bind_host,
      :bind_port => bind_port,
      :metering_secret => node[:ceilometer][:metering_secret],
      :database_connection => db_connection,
#      :database_connection => "mongodb://192.168.1.82:27017/ceilometer",
      :node_hostname => node['hostname'],
      :hypervisor_inspector => "hyperv",
      :libvirt_type => "",
      :time_to_live => time_to_live,
      :alarm_threshold_evaluation_interval => node[:ceilometer][:alarm_threshold_evaluation_interval],
      :lock_path => node[:openstack][:ceilometer][:lock_path],
      :log_dir =>  node[:openstack][:ceilometer][:log_dir],
      :signing_dir => node[:openstack][:ceilometer][:signing_dir]
    )
    if is_compute_agent
      notifies :restart, "service[nova-compute]"
    end
end

template "#{node[:openstack][:config].gsub(/\\/, "/")}/pipeline.yaml" do
  source "pipeline.yaml.erb"
  variables({
      :meters_interval => node[:ceilometer][:meters_interval],
      :cpu_interval => node[:ceilometer][:cpu_interval],
      :disk_interval => node[:ceilometer][:disk_interval],
      :network_interval => node[:ceilometer][:network_interval]
  })
  if is_compute_agent
    notifies :restart, "service[nova-compute]"
  end
end
