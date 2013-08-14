name "hyperv-server"
description "Hyperv Server Role"
run_list(
         "recipe[hyperv::enable_rdp]"
)
default_attributes()
override_attributes()

