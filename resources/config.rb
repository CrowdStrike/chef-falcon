provides :falcon_config
unified_mode true

default_action :set

property :cid, String, sensitive: true,
          description: 'The Customer CID to register the agent with'
property :proxy_host, String,
          description: 'The proxy host to use for the agent'
property :proxy_port, Integer,
          description: 'The proxy port to use for the agent'
property :proxy_enabled, [true, false],
          description: 'Whether or not to enable the proxy for the agent'
property :tags, Array, default: [],
          description: 'The tags to set on the agent'
property :provisioning_token, String, desired_state: false,
          description: 'The provisioning token to use to register the agent'
property :tag_membership, %w(minimum inclusive), default: 'minimum', desired_state: false,
          description: 'Whether specified tags should be treated as a complete list `inclusive` or as a list of tags to add to the existing list `minimum`'

FALCONCTL_CMD = '/opt/CrowdStrike/falconctl'.freeze

def define_resource_requirements
  super

  requirements.assert(:set, :delete) do |a|
    a.assertion { ::File.exist?(FALCONCTL_CMD) }
    a.failure_message Chef::Exceptions::FileNotFound, "Could not find '#{FALCONCTL_CMD}' on the system."
    a.whyrun "Assuming '#{FALCONCTL_CMD}' exists and falcon is installed."
  end
end

load_current_value do |new_resource|
  desired_cid = new_resource.cid.split('-')[0]
  if desired_cid.casecmp?(node.dig('falcon', 'cid'))
    cid new_resource.cid
  else
    cid node.dig('falcon', 'cid')
  end

  current_tags = node.dig('falcon', 'tags')

  if new_resource.tag_membership.casecmp?('minimum') && (new_resource.tags - current_tags).empty?
    tags new_resource.tags
  else
    tags current_tags
  end

  proxy_host node.dig('falcon', 'proxy', 'host')
  proxy_port node.dig('falcon', 'proxy', 'port').to_i # TODO: ensure it will not fail if nil
  proxy_enabled node.dig('falcon', 'proxy', 'enabled')
end

def delete_option(option)
  shell_out!("#{FALCONCTL_CMD} -df --#{option}")
end

action :set do
  converge_if_changed :cid do
    cmd = "#{FALCONCTL_CMD} -sf --cid=#{new_resource.cid}"
    if property_is_set?(:provisioning_token)
      cmd += " --provisioning-token=#{new_resource.provisioning_token}"
    end
    shell_out!(cmd)
  end

  converge_if_changed :tags do
    converge_by "Setting tags to #{new_resource.tags} with a membership of #{new_resource.tag_membership}" do
      tags = if new_resource.tag_membership.casecmp?('minimum')
               current_tags = node.dig('falcon', 'tags')
               current_tags + (new_resource.tags - current_tags)
             else
               new_resource.tags
             end

      cmd = "#{FALCONCTL_CMD} -sf --tags=#{tags.join(',')}"
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

action :delete do
  if property_is_set?(:cid) && node.dig('falcon', 'cid')
    converge_by "Deleting CID #{new_resource.cid}" do
      delete_option('cid')
    end
  end

  if property_is_set?(:tags) && node.dig('falcon', 'tags').any?
    converge_by "Deleting tags #{new_resource.tags}" do
      delete_option('tags')
    end
  end

  if property_is_set?(:proxy_host) && node.dig('falcon', 'proxy', 'host')
    converge_by "Deleting proxy_host #{new_resource.proxy_host}" do
      delete_option('aph')
    end
  end

  if property_is_set?(:proxy_port) && node.dig('falcon', 'proxy', 'port')
    converge_by "Deleting proxy_port #{new_resource.proxy_port}" do
      delete_option('app')
    end
  end

  if property_is_set?(:proxy_enabled) && node.dig('falcon', 'proxy', 'enabled')
    converge_by "Deleting proxy_enabled #{new_resource.proxy_enabled}" do
      delete_option('apd')
    end
  end
end
