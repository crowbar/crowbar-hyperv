#
# Windows features required:
#

default[:features_list][:hyperv] = ["Microsoft-Hyper-V", "Microsoft-Hyper-V-Management-PowerShell"]
default[:features_list][:management] = ["Remote-Desktop-Services"]
default[:features_list][:iscsi_target] = ["File-Services", "CoreFileServer"]

default[:features_list][:windows] = default[:features_list][:management] + default[:features_list][:hyperv] + default[:features_list][:iscsi_target]

default[:sevenzip][:location] = "#{Chef::Config[:file_cache_path]}/"
default[:sevenzip][:file] = "7z922-x64.msi"
default[:sevenzip][:command] = "\"C:\\Program Files\\7-Zip\\7z.exe\""

default[:cache_location] = "#{Chef::Config[:file_cache_path]}/"

default[:python][:file] = "python-2.7.5.msi"
default[:python][:command] = 'C:\Python27\python.exe'
default[:python][:sitepackages] = 'C:\Python27\lib\site-packages'
default[:python][:path] = 'C:\Python27'
default[:python][:scripts] = 'C:\Python27\Scripts'

default[:python][:archive] = 'python275.zip'
default[:python][:installed] = "#{node[:python][:sitepackages]}\\greenlet.pyd"
default[:python][:pywin32register] = 'pywin32_postinstall.py'

default[:openstack][:location] = 'C:\OpenStack'

default[:openstack][:nova][:name] = "nova"
default[:openstack][:nova][:version] = "2013.2"
default[:openstack][:nova][:file] = "nova-2013.2.tar.gz"
default[:openstack][:nova][:target] = "#{node[:openstack][:location]}"
default[:openstack][:nova][:installed] = "#{node[:python][:path]}\\Scripts\\nova-compute"

default[:openstack][:neutron][:name] = "neutron"
default[:openstack][:neutron][:version] = "2013.2"
default[:openstack][:neutron][:file] = "neutron-2013.2.tar.gz"
default[:openstack][:neutron][:target] = "#{node[:openstack][:location]}"
default[:openstack][:neutron][:installed] = "#{node[:python][:path]}\\Scripts\\neutron-hyperv-agent.exe"

default[:openstack][:instances] = "C:\\OpenStack\\Instances"
default[:openstack][:config] = "C:\\OpenStack\\etc"
default[:openstack][:bin] = "C:\\OpenStack\\bin"
default[:openstack][:log] = "C:\\OpenStack\\log"

default[:service][:file] = "OpenStackService.exe"
default[:service][:nova][:name] = "nova-compute"
default[:service][:nova][:displayname] = "Openstack Nova Compute Service" 
default[:service][:nova][:description] = "Service Wrapper for Openstack Nova Compute - Manages the Openstack Nova Compute as a Windows Service"
default[:service][:neutron][:name] = "neutron-hyperv-agent"
default[:service][:neutron][:displayname] = "OpenStack Neutron Hyper-V Agent Service"
default[:service][:neutron][:description] = "Service Wrapper for Openstack Neutron Hyper-V Agent - Manages the OpenStack Neutron Hyper-V Agent as a Windows Service"
