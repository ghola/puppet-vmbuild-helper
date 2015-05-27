define vmbuildhelper::rabbitmq::vhosts (
  $vhosts
){
  create_resources(rabbitmq_vhost, $vhosts)
}