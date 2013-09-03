#
# Windows features required:
#

default[:features_list][:hyperv] = ["Microsoft-Hyper-V", "Microsoft-Hyper-V-Management-PowerShell"]
default[:features_list][:management] = ["Remote-Desktop-Services"]
default[:features_list][:iscsi_target] = ["File-Services", "CoreFileServer"]

default[:features_list][:windows] = default[:features_list][:management] + default[:features_list][:hyperv] + default[:features_list][:iscsi_target]

default[:time][:server] = "bonehed.lcs.mit.edu"
default[:time][:zone]  = "Eastern Standard Time"

default[:vexasoft][:url]  = "http://cdn.shopify.com/s/files/1/0206/6424/files/Vexasoft_Cmdlet_Library_x64.msi"
default[:vexasoft][:location]  = "#{Chef::Config[:file_cache_path]}/"
default[:vexasoft][:file] = "Vexasoft_Cmdlet_Library_x64.msi"

default[:sevenzip][:url] = "http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.22/7z922-x64.msi?r=&ts=1369426091&use_mirror=kent"
default[:sevenzip][:location] = "#{Chef::Config[:file_cache_path]}/"
default[:sevenzip][:file] = "7z922-x64.msi"
default[:sevenzip][:command] = "\"C:\\Program Files\\7-Zip\\7z.exe\""

default[:cache_location] = "#{Chef::Config[:file_cache_path]}/"

default[:vscpp][:"2008"][:url] = "http://download.microsoft.com/download/d/d/9/dd9a82d0-52ef-40db-8dab-795376989c03/vcredist_x86.exe"
default[:vscpp][:"2008"][:file] = "vcredist_x86.exe"
#default[:vscpp][:"2010"][:url] = "http://download.microsoft.com/download/5/B/C/5BC5DBB3-652D-4DCE-B14A-475AB85EEF6E/vcredist_x86.exe"
#default[:vscpp][:"2012"][:url] = "http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU1/vcredist_x86.exe"

default[:python][:url] = "http://www.python.org/ftp/python/2.7.3/python-2.7.3.msi"
default[:python][:file] = "python-2.7.3.msi"
default[:python][:command] = 'C:\Python27\python.exe'
default[:python][:sitepackages] = 'C:\Python27\lib\site-packages'
default[:python][:path] = 'C:\Python27'

default[:pywin32][:file] = "pywin32-218.win32-py2.7.exe"
default[:pywin32][:target] = "#{node[:python][:sitepackages]}"
default[:pywin32][:installscript] = "#{node[:pywin32][:target]}\\pywin32_postinstall.py"
default[:pywin32][:installed] = "#{node[:pywin32][:target]}\\pywin32_postinstall.py"

default[:pymysql][:url] = "https://pypi.python.org/packages/2.7/M/MySQL-python/MySQL-python-1.2.4.win32-py2.7.exe#md5=313b4ceed0144a3019f87a4fba5168d6"
default[:pymysql][:file] = "MySQL-python-1.2.4.win32-py2.7.exe"
default[:pymysql][:target] = "#{node[:python][:sitepackages]}"
default[:pymysql][:installed] = "#{node[:pymysql][:target]}\\MySQL_python-1.2.4-py2.7.egg-info"

default[:pycrypto][:url] = "http://www.voidspace.org.uk/downloads/pycrypto26/pycrypto-2.6.win32-py2.7.exe"
default[:pycrypto][:file] = "pycrypto-2.6.win32-py2.7.exe"
default[:pycrypto][:target] = "#{node[:python][:sitepackages]}"
default[:pycrypto][:installed] = "#{node[:pycrypto][:target]}\\pycrypto-2.6-py2.7.egg-info"


default[:greenlet][:url] = "https://pypi.python.org/packages/2.7/g/greenlet/greenlet-0.4.0.win32-py2.7.exe#md5=910896116b1e4fd527b8afaadc7132f3"
default[:greenlet][:file] = "greenlet-0.4.0.win32-py2.7.exe"
default[:greenlet][:target] = "#{node[:python][:sitepackages]}"
default[:greenlet][:installed] = "#{node[:greenlet][:target]}\\greenlet.pyd"

default[:m2crypto][:url] = "http://chandlerproject.org/pub/Projects/MeTooCrypto/M2Crypto-0.21.1.win32-py2.7.msi"
default[:m2crypto][:file] = "M2Crypto-0.21.1.win32-py2.7.msi"

default[:easyinstall][:command] = 'C:\Python27\Scripts\easy_install.exe'

default[:distsetup][:url] = "http://python-distribute.org/distribute_setup.py"
default[:distsetup][:file] = "distribute_setup.py"
default[:distsetup][:installed] = "#{node[:easyinstall][:command]}"

default[:pip][:command] = 'C:\Python27\Scripts\pip.exe'

default[:git][:url] = "http://msysgit.googlecode.com/files/Git-1.8.1.2-preview20130201.exe"
default[:git][:command] = "\"C:\\Program Files (x86)\\Git\\bin\\git.exe\""

default[:deps][:nova] = "eventlet iso8601 webob netaddr paste pastedeploy routes wmi sqlalchemy sqlalchemy-migrate kombu==1.0.4 requests==1.2.2 httplib2 alembic pbr"

default[:openstack][:location] = 'C:\OpenStack'
default[:openstack][:git][:clients] = ["python-keystoneclient", "python-cinderclient", "python-glanceclient", "python-quantumclient", "python-novaclient"]
#default[:openstack][:git][:options] = '--branch stable/grizzly --single-branch'

default[:openstack][:nova][:name] = "nova"
default[:openstack][:nova][:version] = "2013.1.1"
default[:openstack][:nova][:url] = "https://launchpad.net/nova/grizzly/2013.1.1/+download/nova-2013.1.1.tar.gz"
default[:openstack][:nova][:file] = "nova-2013.1.1.tar.gz"
default[:openstack][:nova][:target] = "#{node[:openstack][:location]}"
default[:openstack][:nova][:installed] = "#{node[:python][:path]}\\Scripts\\nova-compute"

default[:openstack][:quantum][:name] = "quantum"
default[:openstack][:quantum][:version] = "2013.1.1"
default[:openstack][:quantum][:url] = "https://launchpad.net/quantum/grizzly/2013.1.1/+download/quantum-2013.1.1.tar.gz"
default[:openstack][:quantum][:file] = "quantum-2013.1.1.tar.gz"
default[:openstack][:quantum][:target] = "#{node[:openstack][:location]}"
default[:openstack][:quantum][:installed] = "#{node[:python][:path]}\\Scripts\\quantum-hyperv-agent.exe"

default[:openstack][:instances] = "C:\\OpenStack\\Instances"
default[:openstack][:config] = "C:\\OpenStack\\etc"
default[:openstack][:bin] = "C:\\OpenStack\\bin"
default[:openstack][:log] = "C:\\OpenStack\\log"

default[:service][:file] = "OpenStackService.exe"
default[:service][:nova][:name] = "nova-compute"
default[:service][:nova][:displayname] = "Openstack Nova Compute Service" 
default[:service][:nova][:description] = "Service Wrapper for Openstack Nova Compute - Manages the Openstack Nova Compute as a Windows Service"
#default[:service][:nova][:path] = "#{node[:openstack][:location]}\\#{node[:openstack][:nova][:name]}\\"
default[:service][:quantum][:name] = "quantum-hyperv-agent"
default[:service][:quantum][:displayname] = "OpenStack Quantum Hyper-V Agent Service"
default[:service][:quantum][:description] = "Service Wrapper for Openstack Quantum Hyper-V Agent - Manages the OpenStack Quantum Hyper-V Agent as a Windows Service"
#default[:service][:quantum][:path] = ""
