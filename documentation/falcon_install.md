# falcon_install

The `falcon_install`: resource is a wrapper resource around the native Chef `service` resource and allows you to maintain the state of the Falcon service.

## Actions

The Default action is `:install`
| Name | Description |
| :--- | :---------- |
| **`:install`** | Installs the Falcon sensor. |
| `:remove` | Removes the Falcon sensor. |

## Properties

| Name | Type | Default | Description |
| :--- | :--- | :------ | :---------- |
| version | String |  | The version of the Falcon sensor to install
| version_manage | [true, false] | `false` | Whether or not Chef should enforce a specific version and do upgrades/downgrades
| client_id | String |  | The client id used to authenticate with the Falcon API
| client_secret | String |  | The client secret used to authenticate with the Falcon API
| update_policy | String |  | The update policy to use to determine the package version to download and install
| version_decrement | Integer | `0` | The number of versions to decrement the desired version by
| falcon_cloud | String | `api.crowdstrike.com` | The Falcon API cloud to use
| cleanup_installer | [true, false] | `true` | Whether or not to cleanup the installer after installation
| install_method | ['api', 'local'] | `api` | The method to use to install the Falcon sensor
| package_source | String |  | The path to the package in the local file system
| sensor_tmp_dir | String | `/tmp` | The directory to stage the Falcon package in

## Example

```ruby
falcon_install 'falcon' do
  client_id 'LKJSDLFKJSLKDJFKLJ'
  client_secret 'SDLKFJLKSJDFLKJSDFLK'
  action :install
end
```

```ruby
falcon_install 'falcon' do
  client_id 'LKJSDLFKJSLKDJFKLJ'
  client_secret 'SDLKFJLKSJDFLKJSDFLK'
  falcon_cloud 'api.us-2.crowdstrike.com'
  update_policy 'ACME Policy'
  action :install
end
```

```ruby
falcon_install 'falcon' do
  install_method 'local'
  package_source '/tmp/falcon-sensor.rpm'
  action :install
end
```
