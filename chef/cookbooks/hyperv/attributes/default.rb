#
# Windows features required:
#

default[:features_list][:hyperv] = {
  "Microsoft-Hyper-V" => {
    "restart" => false
  },
  "RSAT-Hyper-V-Tools-Feature" => {
    "restart" => false
  },
  "Microsoft-Hyper-V-Management-Clients" => {
    "restart" => false
  },
  "Microsoft-Hyper-V-Management-Powershell" => {
    "restart" => true
  }
}

default[:features_list][:management] = {
  "Remote-Desktop-Services" => {
    "restart" => false
  }
}

default[:features_list][:iscsi_target] = {
  "File-Services" => {
    "restart" => false
  },
  "CoreFileServer" => {
    "restart" => false
  }
}

default[:features_list][:windows] = default[:features_list][:management].merge(default[:features_list][:hyperv].merge(default[:features_list][:iscsi_target]))

default[:sevenzip][:location] = "#{Chef::Config[:file_cache_path]}/"
default[:sevenzip][:file] = "7z922-x64.msi"
default[:sevenzip][:command] = "\"C:\\Program Files\\7-Zip\\7z.exe\""

default[:cache_location] = "#{Chef::Config[:file_cache_path]}/"

default[:python][:file] = "python-2.7.5.msi"
default[:python][:command] = "C:\\Python27\\python.exe"
default[:python][:sitepackages] = "C:\\Python27\\lib\\site-packages"
default[:python][:path] = "C:\\Python27"
default[:python][:scripts] = "C:\\Python27\\Scripts"

default[:python][:archive] = "python275.zip"
default[:python][:pywin32register] = "pywin32_postinstall.py"
default[:python][:installed] = "#{node[:python][:scripts]}\\#{node[:python][:pywin32register]}"

default[:openstack][:location] = "C:\\OpenStack"
default[:openstack][:src] = "#{node[:openstack][:location]}\\src"
default[:openstack][:instances] = "#{node[:openstack][:location]}\\Instances"
default[:openstack][:config] = "#{node[:openstack][:location]}\\etc"
default[:openstack][:bin] = "#{node[:openstack][:location]}\\bin"
default[:openstack][:log] = "#{node[:openstack][:location]}\\log"

default[:openstack][:tarball_branch] = "stable-liberty"

default[:openstack][:nova][:name] = "nova"
default[:openstack][:nova][:binary] = "#{node[:python][:scripts]}\\nova-compute.exe"
default[:openstack][:nova][:config] = "#{node[:openstack][:config]}\\nova"

default[:openstack][:neutron][:name] = "neutron"
default[:openstack][:neutron][:binary] = "#{node[:python][:scripts]}\\neutron-hyperv-agent.exe"
default[:openstack][:neutron][:config] = "#{node[:openstack][:config]}\\neutron"

default[:openstack][:networking_hyperv][:name] = "networking-hyperv"

default[:openstack][:ceilometer][:name] = "ceilometer"
default[:openstack][:ceilometer][:binary] = "#{node[:python][:scripts]}\\ceilometer-agent-compute.exe"
default[:openstack][:ceilometer][:config] = "#{node[:openstack][:config]}\\ceilometer"
default[:openstack][:ceilometer][:lock_path] = "#{node[:openstack][:location]}\\var\\run\\"
default[:openstack][:ceilometer][:signing_dir] = "#{node[:openstack][:location]}\\var\\cache\\ceilometer\\keystone-signing\\"

default[:service][:file] = "OpenStackService.exe"
default[:service][:nova][:name] = "nova-compute"
default[:service][:nova][:displayname] = "Openstack Nova Compute Service"
default[:service][:nova][:description] = "Service Wrapper for Openstack Nova Compute"
default[:service][:neutron][:name] = "neutron-hyperv-agent"
default[:service][:neutron][:displayname] = "OpenStack Neutron Hyper-V Agent Service"
default[:service][:neutron][:description] = "Service Wrapper for Openstack Neutron Hyper-V Agent"
default[:service][:ceilometer][:name] = "ceilometer-agent-notification"
default[:service][:ceilometer][:displayname] = "OpenStack Ceilometer Agent Notification Service"
default[:service][:ceilometer][:description] = "Service Wrapper for Openstack Ceilometer Agent Notification"
