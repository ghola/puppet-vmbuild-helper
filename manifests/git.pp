class vmbuildhelper::git {
  if $gitconf == undef {
    $gitconf = hiera_hash('git',{ })
  }

  if count($gitconf) > 0 and $gitconf['config']  {
    create_resources(git::config, $gitconf['config'])
  }

  if count($gitconf) > 0 and $gitconf['system-config']  {
    create_resources(vmbuildhelper::git::systemconfig, $gitconf['system-config'])
  }
}