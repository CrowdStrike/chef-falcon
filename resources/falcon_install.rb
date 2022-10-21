provides :falcon_install
unified_mode true

action :install do
  case node['platform_family']
  when 'mac_os_x'
    log 'not yet implemented'
  when 'windows'
    log 'not yet implemented'
  else
    falcon_install_linux 'Install Falcon Sensor' do
      action :install
    end
  end
end

action :remove do
  case node['platform_family']
  when 'mac_os_x'
    log 'not yet implemented'
  when 'windows'
    log 'not yet implemented'
  else
    falcon_install_linux 'Remove Falcon Sensor' do
      action :remove
    end
  end
end
