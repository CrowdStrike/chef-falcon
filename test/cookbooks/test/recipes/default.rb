falcon_install 'falcon' do
  client_id ENV['FALCON_CLIENT_ID']
  client_secret ENV['FALCON_CLIENT_SECRET']
  falcon_cloud ENV['FALCON_CLOUD']
  action :install
end

falcon_config 'falcon' do
  cid ENV['FALCON_CID']
  notifies :restart, 'service[falcon]', :delayed
  action :set
end

falcon_service 'falcon' do
  action [:start, :enable]
end
