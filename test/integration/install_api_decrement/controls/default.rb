# Include common controls
include_controls 'common'

# We want to ensure the package version installed matches the version we expect
# from the /tmp/version file
sensor_tmp_dir = '/tmp'
sensor_version_file = File.join(sensor_tmp_dir, 'version')

describe package('falcon-sensor') do
  its('version') { should match file(sensor_version_file).content.strip }
end
