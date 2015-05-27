define vmbuildhelper::rabbitmq::users (
  $users
){
  create_resources(rabbitmq_user, $users)
}