# include_controls
include_controls 'common'

describe command('/opt/CrowdStrike/falconctl -g --aph') do
  its('stdout') { should match 'aph=proxy.example.com' }
end

describe command('/opt/CrowdStrike/falconctl -g --app') do
  its('stdout') { should match 'app=8080' }
end

describe command('/opt/CrowdStrike/falconctl -g --apd') do
  its('stdout') { should match 'apd=FALSE' }
end

describe command('/opt/CrowdStrike/falconctl -g --tags') do
  its('stdout') { should match 'tags=tag1,tag2' }
end
