control 'package-falcon' do
  desc 'Falcon package is installed'
  describe package('falcon-sensor') do
    it { should be_installed }
  end
end

control 'service-falcon' do
  desc 'Falcon service is running'
  describe service('falcon-sensor') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'config-cid' do
  desc 'CID should be present'
  describe command('/opt/CrowdStrike/falconctl -g --cid') do
    its('stdout') { should match /cid=/ }
  end
end

control 'cleanup-installer' do
  desc 'Installer should be removed'
  describe command('find /tmp | grep "falcon-sensor"').stdout.strip do
    it { should eq '' }
  end
end
