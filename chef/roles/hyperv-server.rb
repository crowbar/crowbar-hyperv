name "hyperv-server"
description "Hyperv Server Role"
run_list(
         "recipe[hyperv::windows_features]"
)
default_attributes()
override_attributes()

