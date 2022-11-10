# Common recipes for most instllations
falcon_config 'falcon' do
  cid ENV['FALCON_CID']
  notifies :restart, 'falcon_service[falcon]', :delayed
  action :set
end

falcon_service 'falcon' do
  action [:start, :enable]
end
