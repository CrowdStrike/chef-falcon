name 'crowdstrike-falcon'
maintainer 'CRWD Solutions Architects'
maintainer_email 'integrations@crowdstrike.com'
license 'All Rights Reserved'
description 'Installs/Configures crowdstrike-falcon'
version '0.1.0'
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
supports 'redhat'
# %w( aix amazon centos fedora freebsd debian oracle mac_os_x redhat suse opensuseleap ubuntu windowszlinux ).each do |os|
#   supports os
# end
