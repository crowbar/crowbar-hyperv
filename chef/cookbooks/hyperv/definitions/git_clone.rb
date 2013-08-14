define :git_clone, :opt => "" do

  repo_name="#{params[:name]}"
  repo_options="#{params[:opt]}"

  directory node[:openstack][:location] do
    action :create
  end

  windows_batch "git_create_repo" do
    code <<-EOH
    cd #{node[:openstack][:location]}
    #{node[:git][:command]} clone #{repo_options} git://github.com/openstack/#{repo_name}
    EOH
    not_if {::File.exists?("#{node[:openstack][:location]}\\#{repo_name}")}
  end

  windows_batch "install_from_repo" do
    code <<-EOH
    cd #{node[:openstack][:location]}
    cd #{repo_name}
    #{node[:python][:command]} setup.py install --force
    EOH
  end


end
