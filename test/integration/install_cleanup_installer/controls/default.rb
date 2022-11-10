# Include common controls
include_controls 'common' do
  skip_control 'cleanup-installer'
end

# Get file location from command
sensor = command('find /tmp | grep "falcon-sensor"').stdout.strip

describe file(sensor) do
  it { should exist }
end
