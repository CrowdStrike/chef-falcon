#
# Cookbook:: chef-falcon
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.
# Chef::Recipe.include(ChefFalcon::Helpers)
# file '/tmp/recipe.txt' do
#   # content {os_name}
#   content os_version
# end

falcon_install 'falcon' do
  action :install
end

falcon_config 'falcon' do
  action :set
  tags ['test', 'test2']
  proxy_host 'proxy.example.com'
  proxy_port 8080
  proxy_enabled true
end
