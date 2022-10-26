provides :falcon_install
unified_mode true

default_action :install

property :version, String,
         description: 'The version of the Falcon sensor to install'
property :version_manage, [true, false], default: false,
         description: 'Whether or not Chef should enforce a specific version and do upgrades/downgrades'
property :client_id, String, sensitive: true, desired_state: false,
          description: 'The client id used to authenticate with the Falcon API'
property :client_secret, String, sensitive: true, desired_state: false,
          description: 'The client secret used to authenticate with the Falcon API'
property :update_policy, String, desired_state: false,
          description: 'The update policy to use to determine the package version to download and install'
property :version_decrement, Integer, default: 0, desired_state: false,
          description: 'The number of versions to decrement the desired version by'
property :falcon_cloud, String, default: 'api.crowdstrike.com', desired_state: false,
          description: 'The Falcon API cloud to use'
property :cleanup_installer, [true, false], default: true, desired_state: false,
          description: 'Whether or not to cleanup the installer after installation'
property :install_method, ['api'], default: 'api', desired_state: false,
          description: 'The method to use to install the Falcon sensor'
property :sensor_tmp_dir, String, default: '/tmp', desired_state: false,
          description: 'The directory to stage the Falcon package in'

action_class do
  include ChefFalcon::Helpers
end

def insync?(new_resource, desired_version)
  installed_version = node.dig('falcon', 'version')
  return desired_version == installed_version if new_resource.version_manage
  return true unless installed_version.nil?
  false
end

# Get falcon package name
PACKAGE_NAME = 'falcon-sensor'.freeze

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
        headers({ 'Authorization' => "Bearer #{sensor_info['bearer_token']}", 'User-Agent' => 'crowdstrike-chef/0.1.0' })
        action :create
      end
    end

    package 'falcon' do
      source sensor_info['file_path']
      only_if { ::File.exist?(sensor_info['file_path']) }
      provider Chef::Provider::Package::Dpkg if debian?
      options '--force-all' if debian?
      action :install
      notifies :run, 'execute[falcon]', :immediately if debian?
    end

    # Only run on debian based systems after package install
    execute 'falcon' do
      command 'apt -f -y install'
      only_if { debian? }
      action :nothing
    end

    if new_resource.cleanup_installer
      file sensor_info['file_path'] do
        action :delete
      end
    end
  end
end

action :remove do
  package 'falcon' do
    package_name PACKAGE_NAME
    action :remove
  end
end
