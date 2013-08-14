define :hyperv_service do

  hyperv_name="hyperv-#{params[:name]}"

  service hyperv_name do
    if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
      restart_command "restart #{hyperv_name}"
      stop_command "stop #{hyperv_name}"
      start_command "start #{hyperv_name}"
      status_command "status #{hyperv_name} | cut -d' ' -f2 | cut -d'/' -f1 | grep start"
    end
    supports :status => true, :restart => true
    action [:enable, :start]
    subscribes :restart, resources(:template => node[:hyperv][:config_file])
  end

end
