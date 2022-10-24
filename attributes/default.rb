# falcon::install
default['falcon']['package_name'] = case node['kernel']['name']
                                    when 'Linux'
                                      'falcon-sensor'
                                    when 'windows'
                                      'CrowdStrike Falcon Sensor'
                                    else
                                      'falcon'
                                    end
default['falcon']['install_method'] = 'api'
default['falcon']['cleanup_installer'] = true
default['falcon']['client_id'] = nil
default['falcon']['client_secret'] = nil
default['falcon']['falcon_cloud'] = 'api.crowdstrike.com'
default['falcon']['version'] = nil
default['falcon']['update_policy'] = nil
default['falcon']['version_decrement'] = 0
default['falcon']['sensor_tmp_dir'] = case node['kernel']['name']
                                      when 'windows'
                                        'C:\\windows\\temp'
                                      else
                                        '/tmp'
                                      end


# falcon::config
default['falcon']['cid'] = nil
default['falcon']['provisioning_token'] = nil
default['falcon']['proxy_host'] =  nil
default['falcon']['proxy_port'] = nil
default['falcon']['proxy_enabled'] = nil
default['falcon']['tags'] = []

# falcon::service
default['falcon']['service_name'] = case node['kernel']['name']
                                    when 'Linux'
                                      'falcon-sensor'
                                    when 'windows'
                                      'CSFalconService'
                                    else
                                      'com.crowdstrike.falcon.UserAgent'
                                    end
