class vmbuildhelper::motd {
  if $motdconf == undef {
    $motdconf  = hiera_hash('motd',{ })
  }

  $provisionenv = hiera('provisionenv')

  if $provisionenv == 'project' {
    class { '::motd':
      template => $motdconf['template_path']
    }
  }

}