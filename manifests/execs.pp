class vmbuildhelper::execs {
  if $execconf == undef {
    $execconf = hiera_hash('execs',{ })
  }

  if count($execconf) > 0 {
    create_resources(exec, $execconf)
  }
}