require_relative './falconapi'

module ChefFalcon
  module Helpers
    # Build sensor installer query
    def build_sensor_installer_query(platform_name:, os_name: nil, version: nil, os_version: nil)
      query = "platform:'#{platform_name.downcase}'"
      unless os_version.nil?
        query += "+os_version:'#{os_version}'"
      end
      query += if node['cpu']['architecture'].casecmp('arm64').zero?
                 "+os_version:~'arm64'"
               else
                 "+os_version:!~'arm64'"
               end
      unless version.nil?
        query += "+version:'#{version}'"
      end
      unless os_name.nil?
        query += "+os:'#{os_name}'"
      end
      query
    end

    # Returns the platform name in the format expected by the falcon api
    def platform
      if node['kernel']['name'].casecmp('darwin').zero?
        return 'Mac'
      end
      node['kernel']['name'].capitalize
    end

    # Returns the version of the os in the format expected by the falcon api
    def os_version
      # os_release_major = scope['facts']['os']['release']['major']
      os_release_major = node['platform_version'].to_i

      # Return nil for Mac and Windows
      return if node['kernel']['name'].casecmp('darwin').zero? || node['kernel']['name'].casecmp('windows').zero?

      # For Linux, return *VERSION*
      "*#{os_release_major}*"
    end

    # Return the OS name in the format expected by the falcon api
    def os_name
      platform_family = node['platform_family']

      return 'macOS' if platform_family.casecmp('mac_os_x').zero?
      return 'Windows' if platform_family.casecmp('windows').zero?

      if platform_family.casecmp('Amazon').zero?
        return 'Amazon Linux'
      end

      # Return *RHEL* for RHEL Family
      return '*RHEL*' if rhel?
      node['platform'].capitalize
    end

    def sensor_download_info(client_id, client_secret, options)
      platform_name = platform()
      os_name = os_name()

      falcon_api = Api::FalconApi.new(falcon_cloud: options[:falcon_cloud], client_id: client_id, client_secret: client_secret)
      falcon_api.platform_name = platform_name

      # If version is provied, use it to get the sensor package info
      if options.key?(:version) && !options[:version].nil?
        query = build_sensor_installer_query(platform_name: platform_name, version: options[:version], os_name: os_name, os_version: os_version)
        installer = falcon_api.falcon_installers(query)[0]
      # If update_policy is provided, use it to get the sensor package info
      elsif options.key?(:update_policy) && !options[:update_policy].nil?
        falcon_api.update_policy = options[:update_policy]
        version = falcon_api.version_from_update_policy
        query = build_sensor_installer_query(platform_name: platform_name, version: version, os_name: os_name, os_version: os_version)
        installer = falcon_api.falcon_installers(query)[0]
      # If neither are provided, use the `version_decrement` to pull the n-x version for the platform and os`
      else
        query = build_sensor_installer_query(platform_name: platform_name, os_name: os_name, os_version: os_version)
        version_decrement = options[:version_decrement]
        installers = falcon_api.falcon_installers(query)

        if version_decrement >= installers.length
          Chef::Log.error("The version_decrement is greater than the number of versions available for Platform: #{platform_name} and OS: #{os_name}")
          raise
        end

        installer = installers[version_decrement]
        version = installer['version']
      end

      file_path = File.join(options[:sensor_tmp_dir], installer['name'])

      version = version.gsub(/(\d+\.\d+)\.(\d+)/, '\1.0.\2') if platform_name.casecmp('Linux').zero?
      version += ".el#{os_version}".delete('*') if os_name.casecmp('*RHEL*').zero?
      version += ".amzn#{os_version}".delete('*')  if os_name.casecmp('Amazon Linux').zero?

      {
        'bearer_token' => falcon_api.bearer_token,
        'version' => version,
        'url' => "https://#{options[:falcon_cloud]}/sensors/entities/download-installer/v1?id=#{installer['sha256']}",
        'file_path' => file_path,
        'platform_name' => platform_name,
        'os_name' => os_name,
      }
    end
  end
end
