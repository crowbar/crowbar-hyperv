#
# Windows features required:
#
# Original featres list:
#default[:features_list][:hyperv] = ["Hyper-V", "Hyper-V-PowerShell"]
#default[:features_list][:management] = ["RSAT", "Remote-Desktop-Services"]
#default[:features_list][:iscsi_target] = ["FS-iSCSITarget-Server", "iSCSITarget-VSS-VDS"]

# Actual features list adapted on DISM installer list of available features
default[:features_list][:hyperv] = ["Microsoft-Hyper-V", "RSAT-Hyper-V-Tools-Feature", "Microsoft-Hyper-V-Management-PowerShell"]
default[:features_list][:management] = ["RSAT", "ServerManager-Core-RSAT", "ServerManager-Core-RSAT-Role-Tools", "RSAT-Hyper-V-Tools-Feature", "Remote-Desktop-Services"]
default[:features_list][:iscsi_target] = ["File-Services", "CoreFileServer", "iSCSITargetServer"]

# Feature can not be identified: 
#, "iSCSITarget-VSS-VDS"]

default[:features_list][:windows] = default[:features_list][:management] + default[:features_list][:hyperv] + default[:features_list][:iscsi_target]

default[:sevenzip][:url] = "http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.22/7z922-x64.msi?r=&ts=1369426091&use_mirror=kent"
default[:sevenzip][:command] = "\"C:\\Program Files\\7-Zip\\7z.exe\""

default[:python][:url] = "http://www.python.org/ftp/python/2.7.3/python-2.7.3.msi"
default[:python][:command] = 'C:\Python27\python.exe'
default[:python][:sitepackages] = 'C:\Python27\lib\site-packages'
default[:python][:path] = 'C:\Python27'

default[:pywin32][:location] = "#{Chef::Config[:file_cache_path]}/pywin32-218.win32-py2.7.exe"
default[:pywin32][:target] = "#{node[:python][:sitepackages]}"
default[:pywin32][:installscript] = "#{node[:pywin32][:target]}\\pywin32_postinstall.py"
default[:pywin32][:installed] = "#{node[:pywin32][:target]}\\pywin32_postinstall.py"

default[:pymysql][:url] = "https://pypi.python.org/packages/2.7/M/MySQL-python/MySQL-python-1.2.4.win32-py2.7.exe#md5=313b4ceed0144a3019f87a4fba5168d6"
default[:pymysql][:location] = "#{Chef::Config[:file_cache_path]}/MySQL-python-1.2.4.win32-py2.7.exe"
default[:pymysql][:target] = "#{node[:python][:sitepackages]}"
default[:pymysql][:installed] = "#{node[:pymysql][:target]}\\MySQL_python-1.2.4-py2.7.egg-info"

default[:greenlet][:url] = "https://pypi.python.org/packages/2.7/g/greenlet/greenlet-0.4.0.win32-py2.7.exe#md5=910896116b1e4fd527b8afaadc7132f3"
default[:greenlet][:location] = "#{Chef::Config[:file_cache_path]}/greenlet-0.4.0.win32-py2.7.exe"
default[:greenlet][:target] = "#{node[:python][:sitepackages]}"
default[:greenlet][:installed] = "#{node[:greenlet][:target]}\\greenlet.pyd"

default[:m2crypto][:url] = "http://chandlerproject.org/pub/Projects/MeTooCrypto/M2Crypto-0.21.1.win32-py2.7.msi"

default[:easyinstall][:command] = 'C:\Python27\Scripts\easy_install.exe'

default[:distsetup][:url] = "https://bitbucket.org/pypa/setuptools/raw/default/ez_setup.py"
default[:distsetup][:location] = "#{Chef::Config[:file_cache_path]}/ez_setup.py"
default[:distsetup][:installed] = "#{node[:easyinstall][:command]}"

default[:pip][:command] = 'C:\Python27\Scripts\pip.exe'

#default[:git][:url] = "http://msysgit.googlecode.com/files/Git-1.8.1.2-preview20130201.exe"
#default[:git][:command] = "\"C:\\Program Files (x86)\\Git\\bin\\git.exe\""

default[:deps][:nova] = "eventlet iso8601 webob netaddr paste pastedeploy routes wmi sqlalchemy sqlalchemy-migrate kombu"

default[:openstack][:location] = 'C:\OpenStack'
#default[:openstack][:git][:clients] = ["python-keystoneclient", "python-cinderclient", "python-glanceclient", "python-quantumclient", "python-novaclient"]
#default[:openstack][:git][:options] = '--branch stable/grizzly --single-branch'
default[:openstack][:git][:nova][:name] = "nova"
default[:openstack][:git][:nova][:url] = "https://launchpad.net/nova/grizzly/2013.1.1/+download/nova-2013.1.1.tar.gz"
default[:openstack][:git][:quantum][:name] = "quantum"
default[:openstack][:git][:quantum][:url] = "https://launchpad.net/quantum/grizzly/2013.1.1/+download/quantum-2013.1.1.tar.gz"
