# falcon_service

The `falcon_service`: resource is a wrapper resource around the native Chef `service` resource and allows you to maintain the state of the Falcon service.

## Actions

The Default action is `:start`
| Name | Description |
| :--- | :---------- |
| `:disable` | Disable the service from starting at boot. |
| `:enable` | Enable the service at boot. |
| `:reload` | Reload the configuration for this service. |
| `:restart` | Restart the service. |
| **`:start`** | Start the service, and keep it running until stopped or disabled.
| `:stop` | Stop the service. |

## Properties

| Name | Type | Default | Description |
| :--- | :--- | :------ | :---------- |
| service_name | String | `falcon-sensor` | The name of the falcon service


## Example

```ruby
falcon_service 'falcon' do
  action [:start, :enable]
end
```
