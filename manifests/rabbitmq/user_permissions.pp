define vmbuildhelper::rabbitmq::user_permissions (
  $user_permissions
){
  create_resources(rabbitmq_user_permissions, $user_permissions)
}