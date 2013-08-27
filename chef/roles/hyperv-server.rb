name "hyperv-server"
description "Hyperv Server Role"
run_list(
         "recipe[hyperv::windows_features]",
         "recipe[hyperv::set_time]",
         "recipe[hyperv::setup_networking]",
         "recipe[hyperv::7zip]",
         "recipe[hyperv::python]",
         "recipe[hyperv::pywin32]",
         "recipe[hyperv::distsetup]",
         # "recipe[hyperv::pymysql]",
         "recipe[hyperv::m2crypto]",
         "recipe[hyperv::pycrypto]",
         "recipe[hyperv::greenlet]",
         "recipe[hyperv::lxml]",
         "recipe[hyperv::pip]",
         "recipe[hyperv::nova_deps]",
         "recipe[hyperv::openstack_install]",
         "recipe[hyperv::config]",
         "recipe[hyperv::register_services]"
)
default_attributes()
override_attributes()

