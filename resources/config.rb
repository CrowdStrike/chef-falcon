provides :falcon_config
unified_mode true

default_action :set

property :cid, String
property :provisioning_token, String, desired_state: false
property :proxy_host, String
property :proxy_port, Integer
property :proxy_enabled, [true, false]
property :tags, Array
property :tag_membership, %w(minimum inclusive), default: 'minimum', desired_state: false

FALCONCTL_CMD = '/opt/CrowdStrike/falconctl'.freeze

def define_resource_requirements
  super

  requirements.assert(:set, :delete) do |a|
    a.assertion { ::File.exist?('/opt/CrowdStrike/falconctl') }
    a.failure_message Chef::Exceptions::FileNotFound, "Could not find '/opt/CrowdStrike/falconctl' on the system."
    a.whyrun "Assuming '/opt/CrowdStrike/falconctl' exists and falcon is installed."
  end
end

load_current_value do |new_resource|
  desired_cid = new_resource.cid.split('-')[0]
  if desired_cid.casecmp?(node.dig('falcon', 'cid'))
    cid new_resource.cid
  else
    cid node.dig('falcon', 'cid')
  end

  tags node.dig('falcon', 'tags')
  proxy_host node.dig('falcon', 'proxy', 'host')
  proxy_port node.dig('falcon', 'proxy', 'port').to_i
  proxy_enabled node.dig('falcon', 'proxy', 'enabled')
end

action :set do
  converge_if_changed :cid do
    converge_by "Setting CID to #{new_resource.cid}" do
      cmd = "#{FALCONCTL_CMD} -sf --cid=#{new_resource.cid}"
      if property_is_set?(:provisioning_token)
        cmd += " --provisioning-token=#{new_resource.provisioning_token}"
      end
      shell_out!(cmd)
    end
  end

  converge_if_changed :tags do
    converge_by "Setting tags to #{new_resource.tags}" do
      cmd = "#{FALCONCTL_CMD} -sf --tags=#{new_resource.tags.join(',')}"
      shell_out!(cmd)
    end
  end

  converge_if_changed :proxy_host do
    converge_by "Setting proxy_host to #{new_resource.proxy_host}" do
      cmd = "#{FALCONCTL_CMD} -sf --aph=#{new_resource.proxy_host}"
      shell_out!(cmd)
    end
  end

  converge_if_changed :proxy_port do
    converge_by "Setting proxy_port to #{new_resource.proxy_port}" do
      cmd = "#{FALCONCTL_CMD} -sf --app=#{new_resource.proxy_port}"
      shell_out!(cmd)
    end
  end

  converge_if_changed :proxy_enabled do
    converge_by "Setting proxy_enabled to #{new_resource.proxy_enabled}" do
      cmd = "#{FALCONCTL_CMD} -sf --apd=#{!new_resource.proxy_enabled}"
      shell_out!(cmd)
    end
  end
end
