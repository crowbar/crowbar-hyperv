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
default[:python][:command] = 'C:\Python27\python.exe'
default[:python][:sitepackages] = 'C:\Python27\lib\site-packages'
default[:python][:path] = 'C:\Python27'
default[:python][:scripts] = 'C:\Python27\Scripts'

default[:python][:archive] = "python275.zip"
default[:python][:pywin32register] = "pywin32_postinstall.py"
default[:python][:installed] = "#{node[:python][:scripts]}\\#{node[:python][:pywin32register]}"

default[:openstack][:location] = 'C:\OpenStack'
default[:openstack][:tarball_branch] = 'stable-liberty'

default[:openstack][:nova][:name] = "nova"
default[:openstack][:nova][:target] = "#{node[:openstack][:location]}"

default[:openstack][:neutron][:name] = "neutron"
default[:openstack][:neutron][:target] = "#{node[:openstack][:location]}"

default[:openstack][:networking_hyperv][:name] = "networking-hyperv"
default[:openstack][:networking_hyperv][:target] = "#{node[:openstack][:location]}"

default[:openstack][:ceilometer][:name] = "ceilometer"
default[:openstack][:ceilometer][:target] = "#{node[:openstack][:location]}"
default[:openstack][:ceilometer][:lock_path] = "C:\\OpenStack\\var\\run\\"
default[:openstack][:ceilometer][:signing_dir] = "C:\\OpenStack\\var\\cache\\ceilometer\\keystone-signing\\"

default[:openstack][:instances] = "C:\\OpenStack\\Instances"
default[:openstack][:config] = "C:\\OpenStack\\etc"
default[:openstack][:bin] = "C:\\OpenStack\\bin"
default[:openstack][:log] = "C:\\OpenStack\\log"

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
