class vmbuildhelper::logintweaks {
  $provisionenv = hiera('provisionenv')

  if $provisionenv == 'project' {
    file { '/etc/profile.d/workdir.sh':
      ensure  => 'present',
      content => "cd /var/www/${::fqdn}"
    }
  }
}