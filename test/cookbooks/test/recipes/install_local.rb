execute 'download' do
  command 'curl -L https://raw.githubusercontent.com/carlosmmatos/falcon-scripts/chef-pre-converge/bash/install/falcon-linux-install.sh | FALCON_CLOUD=us-1 bash'
  action :run
  # not_if package falcon-sensor exists
  not_if { ::File.directory?('/opt/CrowdStrike') }
end

falcon_install 'falcon' do
  install_method 'local'
  # Use shell_out to get the path to the falcon package
  package_source shell_out('find /tmp | grep falcon-sensor').stdout.strip
  action :install
end

include_recipe 'test::common'
