client_id = ENV['FALCON_CLIENT_ID']
client_secret = ENV['FALCON_CLIENT_SECRET']
falcon_cloud = ENV['FALCON_CLOUD']
sensor_tmp_dir = '/tmp'

falcon_install 'falcon' do
  client_id client_id
  client_secret client_secret
  falcon_cloud falcon_cloud
  version_decrement 2
  action :install
end

# Use the helpers library to get the version of the requested package
::Chef::DSL::Recipe.send(:include, ChefFalcon::Helpers)

sensor_info = sensor_download_info(client_id, client_secret, {
    version_decrement: 2,
    sensor_tmp_dir: sensor_tmp_dir,
    falcon_cloud: falcon_cloud,
  })

file "#{sensor_tmp_dir}/version" do
  content sensor_info['version']
end

include_recipe 'test::common'
