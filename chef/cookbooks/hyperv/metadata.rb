maintainer       "Cloudbase Solutions"
maintainer_email "ociuhandu@cloudbasesolutions.com"
license          "Apache 2.0"
description      "Installs/Configures Nova Compute and Neutron Agent on Hyper-V"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1"

supports         "windows"

depends          "windows"
depends          "powershell"
depends          "crowbar-openstack"
#depends          "keystone"
#depends          "neutron"
#depends          "glance"
