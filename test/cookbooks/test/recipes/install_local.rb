# Stage the sensor package on disk with the cookbook's own API helper, then
# install it from that file with install_method 'local'.
::Chef::DSL::Recipe.send(:include, ChefFalcon::Helpers)

sensor_info = sensor_download_info(ENV['FALCON_CLIENT_ID'], ENV['FALCON_CLIENT_SECRET'],
                                   version_decrement: 0,
                                   sensor_tmp_dir: '/tmp',
                                   falcon_cloud: ENV['FALCON_CLOUD'])

remote_file sensor_info['file_path'] do
  source sensor_info['url']
  headers('Authorization' => "Bearer #{sensor_info['bearer_token']}",
          'User-Agent' => 'crowdstrike-chef/0.1.3')
  sensitive true
  action :create_if_missing
  not_if { ::File.directory?('/opt/CrowdStrike') }
end

falcon_install 'falcon' do
  install_method 'local'
  package_source sensor_info['file_path']
  action :install
end

include_recipe 'test::common'
