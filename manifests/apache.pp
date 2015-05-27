class vmbuildhelper::apache {
  if $apacheconf == undef {
    $apacheconf = hiera_hash('apache',{ })
  }

  class { '::apache':
    default_vhost => $apacheconf['default_vhost'],
    mpm_module    => $apacheconf['mpm_module'],
  }

  if $apacheconf['vhosts'] {
    create_resources(apache::vhost, $apacheconf['vhosts'])
  }

  if $apacheconf['modules'] and count($apacheconf['modules']) > 0 {
    vmbuildhelper::apache::mod { $apacheconf['modules']:
      require => Class['php']
    }
  }

# makes sure apache uses the correct umask
  exec { 'apache umask':
    command => '/bin/echo "umask 002" >> /etc/sysconfig/httpd',
    unless  => '/bin/grep -Fx "umask 002" /etc/sysconfig/httpd',
    require => Class['apache'],
    notify  => Service['httpd']
  }

  User<| title == apache |> { groups +> [ "wheel" ] }

  $provisionenv = hiera('provisionenv')

  if $provisionenv == 'project' {
  ### The '.machine' vhost content ###
    file { "/var/www/${::fqdn}.machine/index.php":
      ensure  => 'present',
      content => '<?php phpinfo();',
      require => File["/var/www/${::fqdn}.machine"]
    }

  ### Ensure main vhost dir is created so that apache:vhost does not attempt to set file permissions which will fail due to smb mount
    file { "/var/www/${::fqdn}":
      ensure => directory
    }
  }
}
