# Include common controls
include_controls 'common' do
  skip_control 'package-falcon'
end

falcon_version = inspec.os_env('FALCON_VERSION').content
falcon_version = falcon_version.gsub(/(\d+\.\d+)\.(\d+)/, '\1.0-\2')

# Ensure falcon-sensor package installed to specific version
describe package('falcon-sensor') do
  it { should be_installed }
  its('version') { should match falcon_version }
end
