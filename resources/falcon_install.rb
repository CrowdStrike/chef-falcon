provides :falcon_install
unified_mode true

property :client_id, String, sensitive: true, desired_state: false
property :client_secret, String, sensitive: true, desired_state: false
# property :version, String, desired_state: false
# property :update_policy, String, desired_state: false
property :version_decrement, Integer, default: 0, desired_state: false
property :falcon_cloud, String, default: 'api.crowdstrike.com', desired_state: false
# property :cleanup_installer, [true, false], default: true, desired_state: false
# property :install_method, [:api, :local], default: 'api', desired_state: false
property :sensor_tmp_dir, String, default: '/tmp', desired_state: false

action_class do
  include ChefFalcon::Helpers
end

action :install do
  # Create file with contents
  sensor_info = sensor_download_info(new_resource.client_id, new_resource.client_secret, {
    version_decrement: new_resource.version_decrement,
    sensor_tmp_dir: new_resource.sensor_tmp_dir,
    falcon_cloud: new_resource.falcon_cloud,
    })

  package 'falcon' do
    source sensor_info['file_path']
    action :install
  end
end
