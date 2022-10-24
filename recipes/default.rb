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
  client_id ''
  client_secret ''
end
