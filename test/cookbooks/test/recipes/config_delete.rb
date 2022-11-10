falcon_config 'falcon' do
  # cid ENV['FALCON_CID']
  proxy_host 'http://proxy.example.com'
  proxy_port 8080
  proxy_enabled true
  tags %w(tag1 tag2)
  notifies :restart, 'falcon_service[falcon]', :delayed
  action :delete
end
