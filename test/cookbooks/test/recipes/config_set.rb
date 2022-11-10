falcon_install 'falcon' do
  client_id ENV['FALCON_CLIENT_ID']
  client_secret ENV['FALCON_CLIENT_SECRET']
  falcon_cloud ENV['FALCON_CLOUD']
  action :install
end

falcon_config 'falcon' do
  cid ENV['FALCON_CID']
  proxy_host 'http://proxy.example.com'
  proxy_port 8080
  proxy_enabled true
  tags %w(tag1 tag2)
  notifies :restart, 'falcon_service[falcon]', :delayed
  action :set
end

falcon_service 'falcon' do
  action [:start, :enable]
end
