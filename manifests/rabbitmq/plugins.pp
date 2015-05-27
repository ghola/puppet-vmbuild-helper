# Rabbitmq helpers to bypass puppet module bug of not starting the service before running rabbitmqctl

define vmbuildhelper::rabbitmq::plugins (
  $plugins
){
  create_resources(rabbitmq_plugin, $plugins)
}
