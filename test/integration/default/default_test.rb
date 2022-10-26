# Chef InSpec test for recipe chef-falcon::default

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

# Ensure falcon-sensor is installed
describe package('falcon-sensor') do
  it { should be_installed }
end

# Ensure falcon-sensor is running and enabled
describe service('falcon-sensor') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
