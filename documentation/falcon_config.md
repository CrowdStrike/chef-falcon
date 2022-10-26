# falcon_config

The `falcon_config`: resource configures the Falcon sensor.

## Actions

The Default action is `:set`
| Name | Description |
| :--- | :---------- |
| **`:set`** | Set options for the Falcon sensor |
| `:delete` | Delete options for the Falcon sensor |


## Properties

| Name | Type | Default | Description |
| :--- | :--- | :------ | :---------- |
| cid | String |  | The Customer CID to register the agent with
| proxy_host | String |  | The proxy host to use for the agent
| proxy_port | Integer |  | The proxy port to use for the agent
| proxy_enabled | [true, false] |  | Whether or not to enable the proxy for the agent
| tags | Array | `[]` | The tags to set on the agent
| provisioning_token | String |  | The provisioning token to use to register the agent
| tag_membership | ["minimum", "inclusive"] | `minimum` | Whether specified tags should be treated as a complete list `inclusive` or as a list of tags to add to the existing list `minimum`


## Example

```ruby
falcon_config 'falcon' do
  cid 'JKLJSDLKFJLKSJDFLKJSDLKFJ-28'
  notifies :restart, 'falcon_service[falcon]', :delayed
  action :set
end
```

```ruby
falcon_config 'falcon' do
  cid 'JKLJSDLKFJLKSJDFLKJSDLKFJ-28'
  tags %w(tag1 tag2 tag3)
  proxy_host 'http://example.com'
  proxy_port 8080
  proxy_enabled true
  notifies :restart, 'falcon_service[falcon]', :delayed
  action :set
end
```
