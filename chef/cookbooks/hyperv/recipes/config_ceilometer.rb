raise unless node[:platform_family] == "windows"

keystone_settings = KeystoneHelper.keystone_settings(node, :ceilometer)

bind_host = node[:ceilometer][:api][:host]
bind_port = node[:ceilometer][:api][:port]

metering_time_to_live = node[:ceilometer][:database][:metering_time_to_live]
if metering_time_to_live > 0
  # We store the value of time to live in days, but config file expects seconds
  metering_time_to_live = metering_time_to_live * 3600 * 24
end

is_compute_agent = %w(ceilometer-agent-hyperv nova-compute-hyperv).all?{ |role| node.roles.include?(role) }

dirs = [
  node[:openstack][:ceilometer][:config],
  node[:openstack][:ceilometer][:lock_path],
  node[:openstack][:ceilometer][:signing_dir]
]
dirs.each do |dir|
  directory dir do
    action :create
    recursive true
  end
end

template "#{node[:openstack][:ceilometer][:config].gsub(/\\/, "/")}/ceilometer.conf" do
    source "ceilometer.conf.erb"
    variables(
      debug: node[:ceilometer][:debug],
      verbose: node[:ceilometer][:verbose],
      rabbit_settings: fetch_rabbitmq_settings("ceilometer"),
      keystone_settings: keystone_settings,
      bind_host: bind_host,
      bind_port: bind_port,
      metering_secret: node[:ceilometer][:metering_secret],
      # compute agents don't need direct access to the database
      database_connection: "",
      node_hostname: node["hostname"],
      hypervisor_inspector: "hyperv",
      libvirt_type: "",
      time_to_live: metering_time_to_live,
      alarm_threshold_evaluation_interval: node[:ceilometer][:alarm_threshold_evaluation_interval],
      lock_path: node[:openstack][:ceilometer][:lock_path],
      log_dir: node[:openstack][:log],
      signing_dir: node[:openstack][:ceilometer][:signing_dir],
      ceilometer_config: node[:openstack][:ceilometer][:config]
    )
    if is_compute_agent
      notifies :restart, "service[nova-compute]"
    end
end

# Chef 11.4 fails to notify if the path separator is windows like,
# according to https://tickets.opscode.com/browse/CHEF-4082 using gsub
# to replace the windows path separator to linux one
template "#{node[:openstack][:ceilometer][:config].gsub(/\\/, "/")}/pipeline.yaml" do
  source "pipeline.yaml.erb"
  variables({
      meters_interval: node[:ceilometer][:meters_interval],
      cpu_interval: node[:ceilometer][:cpu_interval],
      disk_interval: node[:ceilometer][:disk_interval],
      network_interval: node[:ceilometer][:network_interval]
  })
  if is_compute_agent
    notifies :restart, "service[nova-compute]"
  end
end
