raise if not node[:platform] == 'windows'

# Install Nova Compute Python dependencies

windows_batch "install_novadeps" do
  code <<-EOH
  #{node[:pip][:command]} install #{node[:deps][:nova]}
  EOH
  not_if {::File.exists?("#{node[:python][:sitepackages]}\\amqp")}
end

