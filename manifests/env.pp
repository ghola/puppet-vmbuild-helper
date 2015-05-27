class vmbuildhelper::env {
  if $envconf == undef {
    $envconf = hiera_hash('env',{ })
  }

  create_resources(env::variable, $envconf)
}