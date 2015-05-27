class vmbuildhelper::phpmyadmin {
  if $pmaconf == undef {
    $pmaconf = hiera_hash('phpmyadmin',{ })
  }

  class { '::phpmyadmin':
    enabled          => 'true',
    ip_access_ranges => $pmaconf['ip_access_ranges'],
    require          => Class['mysql::server']
  }

  phpmyadmin::server{ 'default': }

  if $pmaconf['vhost'] {
    phpmyadmin::vhost{ $pmaconf['vhost']: }
  }

  concat::fragment { '01_phpmyadmin_header':
    target  => $::phpmyadmin::params::config_file,
    order   => '02',
    content => "\$cfg['LoginCookieValidity'] = 518400;\n",
  }
}