name 'falcon'
maintainer 'CRWD Cloud Integration Architects'
maintainer_email 'cloud-integrations@crowdstrike.com'
license 'GPL-3.0'
description 'Installs/Configures Falcon sensor'
version '0.1.1'
chef_version '>= 16.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/CrowdStrike/chef-falcon/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/CrowdStrike/chef-falcon'

# For more up-to-date information about supported platforms, please see the docs
# at https://falcon.crowdstrike.com/documentation/20/falcon-sensor-for-linux#operating-systems
%w(almalinux amazon centos debian oracle redhat rockylinux suse ubuntu).each do |os|
  supports os
end
