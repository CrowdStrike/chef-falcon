crowdstrike-falcon Cookbook
================

This cookbook installs and configures the CrowdStrike Falcon sensor.


Requirements
------------
### Platforms
*Supported on:
- Alma/Rocky/CentOS Linux
- Amazon Linux 1|2
- Debian | Ubuntu
- Red Hat Enterprise Linux
- Red Hat CoreOS
- SUSE Linux Enterprise (SLES)

`* Note: Refer to the Falcon documentation for exact versions supported`

Resources
=========


Usage
=====
Use `recipe[rsyslog]` to install and start rsyslog as a basic configured service for standalone systems.

Use `recipe[rsyslog::client]` to have nodes log to a remote server (which is found via the `server_ip` attribute or by the recipe's search call -- see __client__)

Use `recipe[rsyslog::server]` to set up a rsyslog server. It will listen on `node['rsyslog']['port']` protocol `node['rsyslog']['protocol']`.

If you set up a different kind of centralized loghost (syslog-ng, graylog2, logstash, etc), you can still send log messages to it as long as the port and protocol match up with the server software. See __Examples__

Use `rsyslog_file_input` within your recipes to forward log files to
your remote syslog server.


### Examples
A `base` role (e.g., roles/base.rb), applied to all nodes so they are syslog clients:

```ruby
name "base"
description "Base role applied to all nodes
run_list("recipe[rsyslog::client]")
```

Then, a role for the loghost (should only be one):

```ruby
name "loghost"
description "Central syslog server"
run_list("recipe[rsyslog::server]")
```

By default this will set up the clients search for a node with the `loghost` role to talk to the server on TCP port 514. Change the `protocol` and `port` rsyslog attributes to modify this.

If you want to specify another syslog compatible server with a role other than loghost, simply fill free to use the `server_ip` attribute or the `server_search` attribute.

Example role that sets the per host directory:

```ruby
name "loghost"
description "Central syslog server"
run_list("recipe[rsyslog::server]")
default_attributes(
  "rsyslog" => { "per_host_dir" => "%HOSTNAME%" }
)
```

Default rsyslog options are rendered for RHEL family platforms, in `/etc/rsyslog.d/50-default.conf`
with other platforms using a configuration like Debian family defaults.  You can override these
log facilities and destinations using the `rsyslog['default_facility_logs']` hash.

```ruby
name "facility_log_example"
run_list("recipe[rsyslog::default]")
default_attributes(
  "rsyslog" => {
    "facility_logs" => {
      '*.info;mail.none;authpriv.none;cron.none' => "/var/log/messages",
      'authpriv' => '/var/log/secure',
      'mail.*' => '-/var/log/maillog',
      '*.emerg' => '*'
    }
  }
)
```

Development
-----------
This section details "quick development" steps. For a detailed explanation, see [[Contributing.md]].

1. Clone this repository from GitHub:

    $ git clone git@github.com:opscode-cookbooks/rsyslog.git

2. Create a git branch

    $ git checkout -b my_bug_fix

3. Install dependencies:

    $ bundle install

4. Make your changes/patches/fixes, committing appropriately
5. **Write tests**
6. Run the tests:
    - bundle exec foodcritic -f any .
    - bundle exec rspec
    - bundle exec rubocop
    - bundle exec kitchen test

  In detail:
    - Foodcritic will catch any Chef-specific style errors
    - RSpec will run the unit tests
    - Rubocop will check for Ruby-specific style errors
    - Test Kitchen will run and converge the recipes


License & Authors
-----------------
- Author:: Joshua Timberman (<joshua@chef.io>)
- Author:: Denis Barishev (<denz@twiket.com>)
- Author:: Tim Smith (<tsmith84@gmail.com>)

```text
Copyright:: 2009-2015, Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
