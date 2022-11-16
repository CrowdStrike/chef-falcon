# Falcon Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/falcon)](https://supermarket.chef.io/cookbooks/falcon)

This cookbook provides resources for installing and configuring the CrowdStrike Falcon sensor.

## Maintainers

This cookbook maintained by the CrowdStrike Cloud Integration Architects.

<cloud-integrations@crowdstrike.com>

## Requirements

API clients are granted one or more API scopes. Scopes allow access to specific CrowdStrike APIs and describe the actions that an API client can perform.

Ensure the following API scopes are enabled (**_if applicable_**) for this role:

- When `install_method` is set to **api** (default)
  - **Sensor Download** [read]
  - **Sensor update policies** [read]

## Platform Support

\*Supported on:

- Alma/Rocky/CentOS Linux
- Amazon Linux 1|2
- Debian/Ubuntu
- Oracle
- Red Hat Enterprise Linux
- Red Hat CoreOS
- SUSE Linux Enterprise (SLES)

\*Refer to the [Falcon documentation](https://falcon.crowdstrike.com/documentation/20/falcon-sensor-for-linux#operating-systems) for exact versions supported

## Resources

- [falcon_install](https://github.com/CrowdStrike/chef-falcon/blob/main/documentation/falcon_install.md)
- [falcon_config](https://github.com/CrowdStrike/chef-falcon/blob/main/documentation/falcon_config.md)
- [falcon_service](https://github.com/CrowdStrike/chef-falcon/blob/main/documentation/falcon_service.md)

## Usage

- Add `depends 'falcon'` to your cookbook's metadata.rb
- Use the resources shipped in the cookbook in a recipe, the same way you'd use core Chef resources (file, template, directory, package, etc).

```ruby
falcon_install 'falcon' do
  client_id 'LKJSDLFKJSLKDJFKLJ'
  client_secret 'SDLKFJLKSJDFLKJSDFLK'
  action :install
end
```

## Test Cookbooks as Examples

The cookbooks ran under test-kitchen make excellent usage examples.

The test recipes are found at:

```text
test/cookbooks/test/
```

## Getting Started

Here's an example of installing/managing the latest Falcon sensor:

```ruby
falcon_install 'falcon' do
  client_id 'LKJSDLFKJSLKDJFKLJ'
  client_secret 'SDLKFJLKSJDFLKJSDFLK'
  action :install
end

falcon_config 'falcon' do
  cid 'JKLJSDLKFJLKSJDFLKJSDLKFJ-28'
  notifies :restart, 'falcon_service[falcon]', :delayed
  action :set
end

falcon_service 'falcon' do
  action [:start, :enable]
end
```

You might not want to install the latest, and instead be interested in N-1 deployment. The `falcon_install` resource might look like:

```ruby
falcon_install 'falcon' do
  client_id 'LKJSDLFKJSLKDJFKLJ'
  client_secret 'SDLKFJLKSJDFLKJSDFLK'
  version_decrement: 1 # This number corresponds to N-
  action :install
end

... # falcon_config

... # falcon_service
```

You can pass in certain options to configure the Falcon sensor. Here's an example of passing in some tags:

```ruby
... # falcon_install

falcon_config 'falcon' do
  cid 'JKLJSDLKFJLKSJDFLKJSDLKFJ-28'
  tags %w(tag1 tag2)
  notifies :restart, 'falcon_service[falcon]', :delayed
  action :set
end

... # falcon_service
```

See [full documentation](#resources) for each resource and action for more information.

## Authors

![Adversary Lineup](https://raw.githubusercontent.com/CrowdStrike/falconpy/main/docs/asset/adversary-lineup-1.png)

| Name         | Handle        |
| :----------- | :------------ |
| Carlos Matos | @carlosmmatos |
| Frank Falor  | @ffalor       |

## Support

Chef Falcon is an open source project, not a formal CrowdStrike product, to assist developers implement CrowdStrike's Falcon sensor deployment within their organizations. As such it carries no formal support, express or implied.

Is something going wrong?
GitHub Issues are used to report bugs.

Submit a ticket here:
[https://github.com/CrowdStrike/chef-falcon/issues/new/choose](https://github.com/CrowdStrike/chef-falcon/issues/new/choose)
