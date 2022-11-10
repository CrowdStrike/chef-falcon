# include_controls
include_controls 'common'

describe command('/opt/CrowdStrike/falconctl -g --aph') do
  its('stdout') { should match 'aph is not set' }
end

describe command('/opt/CrowdStrike/falconctl -g --app') do
  its('stdout') { should match 'app is not set' }
end

describe command('/opt/CrowdStrike/falconctl -g --apd') do
  its('stdout') { should match 'apd is not set' }
end

describe command('/opt/CrowdStrike/falconctl -g --tags') do
  its('stdout') { should match 'Sensor grouping tags are not set' }
end
