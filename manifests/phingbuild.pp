##### Project builds #####
class vmbuildhelper::phingbuild {
  if $buildsconf == undef {
    $buildsconf = hiera_hash('builds',{ })
  }

  if count($buildsconf) > 0 {
    create_resources(vmbuildhelper::phingbuild::build, $buildsconf)
  }
}