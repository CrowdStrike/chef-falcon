provides :falcon_install
unified_mode true

default_action :install

property :version, String
property :version_manage, [true, false], default: false
property :client_id, String, sensitive: true, desired_state: false
property :client_secret, String, sensitive: true, desired_state: false
property :update_policy, String, desired_state: false
property :version_decrement, Integer, default: 0, desired_state: false
property :falcon_cloud, String, default: 'api.crowdstrike.com', desired_state: false
property :cleanup_installer, [true, false], default: true, desired_state: false
property :install_method, ['api'], default: 'api', desired_state: false
property :sensor_tmp_dir, String, default: '/tmp', desired_state: false

action_class do
  include ChefFalcon::Helpers
end

def insync?(new_resource, desired_version)
  installed_version = node.dig('falcon', 'version')
  return desired_version == installed_version if new_resource.version_manage
  return true unless installed_version.nil?
  false
end

action :install do
  # Create file with contents

  if new_resource.install_method == 'api'
    if new_resource.client_id.nil? || new_resource.client_secret.nil?
      raise ArgumentError, 'client_id and client_secret are required when using the api install method' 
    end

    sensor_info = sensor_download_info(new_resource.client_id, new_resource.client_secret, {
      version_decrement: new_resource.version_decrement,
      sensor_tmp_dir: new_resource.sensor_tmp_dir,
      falcon_cloud: new_resource.falcon_cloud,
      })

    unless insync?(new_resource, sensor_info['version'])
      remote_file 'falcon' do
        path sensor_info['file_path']
        source sensor_info['url']
        headers({ 'Authorization' => "Bearer #{sensor_info['bearer_token']}", 'User-Agent' => 'chef-falcon/0.0.1' })
        action :create
      end
    end

    package 'falcon' do
      source sensor_info['file_path']
      only_if { ::File.exist?(sensor_info['file_path']) }
      action :install
    end

    if new_resource.cleanup_installer
      file sensor_info['file_path'] do
        action :delete
      end
    end
  end
end
