Ohai.plugin(:Falcon) do
  provides 'falcon'
  depends 'packages'

  def to_boolean(str)
    str.casecmp('true').zero? || str.casecmp('1').zero?
  end

  def falconctl_shell_out(option)
    begin
      stdout = shell_out('/opt/CrowdStrike/falconctl -g --' + option).stdout

      return if stdout.empty? || stdout.include?('not set')

      output = if stdout.include?('version')
                 stdout.gsub(/['\s\n]|\(.*\)/, '').split('=')[-1]
               elsif stdout.include?('rfm-reason')
                 stdout.gsub(/^rfm-reason=|['\s\n\.]|\(.*\)/, '')
               elsif stdout.include?('aph')
                 stdout.gsub(/\.$\n/, '').split('=')[-1]
               else
                 stdout.gsub(/["\s\n\.]|\(.*\)/, '').split('=')[-1]
               end
      return output if output
    rescue
      nil
    end
  end

  def get_cid
    falconctl_shell_out('cid')
  end

  def get_aid
    falconctl_shell_out('aid')
  end

  def get_tags
    tags = falconctl_shell_out('tags')
    return [] unless tags
    tags.split(',')
  end

  def get_rfm_reason
    falconctl_shell_out('rfm-reason')
  end

  def get_rfm_state
    rfm_state = falconctl_shell_out('rfm-state')
    return if rfm_state.nil?
    to_boolean(rfm_state)
  end

  def get_apd
    apd = falconctl_shell_out('apd')
    return if apd.nil?
    !to_boolean(apd)
  end

  def get_aph
    falconctl_shell_out('aph')
  end

  def get_app
    falconctl_shell_out('app')
  end

  def get_billing
    falconctl_shell_out('billing')
  end

  collect_data(:default) do
    falcon Mash.new
    falcon[:version] = packages['falcon-sensor']['version'] if packages['falcon-sensor']
    falcon[:aid] = get_aid
    falcon[:cid] = get_cid
    falcon[:tags] = get_tags
    falcon[:rfm] = Mash.new
    falcon[:rfm][:state] = get_rfm_state
    falcon[:rfm][:reason] = get_rfm_reason if get_rfm_state
    falcon[:proxy] = Mash.new
    falcon[:proxy][:enabled] = get_apd
    falcon[:proxy][:host] = get_aph
    falcon[:proxy][:port] = get_app
    falcon[:billing] = get_billing
  end
end
