provides :falcon_service
unified_mode true

default_action [ :start ]

property :service_name, String,
          default: if linux?
                     'falcon-sensor'
                   elsif windows?
                     'CSFalconService'
                   end,
          description: 'The name of the falcon service'

action :start do
  service new_resource.service_name do
    action :start
  end
end

action :stop do
  service new_resource.service_name do
    action :stop
  end
end

action :restart do
  service new_resource.service_name do
    action :restart
  end
end

action :enable do
  service new_resource.service_name do
    action :enable
  end
end

action :disable do
  service new_resource.service_name do
    action :disable
  end
end

action :reload do
  service new_resource.service_name do
    action :reload
  end
end
