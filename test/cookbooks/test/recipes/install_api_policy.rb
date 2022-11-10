falcon_install 'falcon' do
  client_id ENV['FALCON_CLIENT_ID']
  client_secret ENV['FALCON_CLIENT_SECRET']
  falcon_cloud ENV['FALCON_CLOUD']
  update_policy 'Chef Test'
  action :install
end

include_recipe 'test::common'
