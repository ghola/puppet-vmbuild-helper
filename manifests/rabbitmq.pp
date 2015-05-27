class vmbuildhelper::rabbitmq {
  if $rabbitconf == undef {
    $rabbitconf = hiera_hash('rabbitmq',{ })
  }

  if count($rabbitconf) > 0 {
    class { '::rabbitmq':
      admin_enable     => true,
      node_ip_address  => $rabbitconf['node_ip_address'],
      version          => $rabbitconf['version'],
      package_source   => $rabbitconf['package_source'],
      package_provider => $rabbitconf['package_provider'],
      config_variables => $rabbitconf['config_variables']
    }

    if $rabbitconf['plugins'] {
      vmbuildhelper::rabbitmq::plugins { 'blah':
        plugins => $rabbitconf['plugins'],
        require => Service['rabbitmq-server']
      }
    }

    if $rabbitconf['vhosts'] {
      vmbuildhelper::rabbitmq::vhosts { 'blah':
        vhosts  => $rabbitconf['vhosts'],
        require => Service['rabbitmq-server']
      }
    }

    if $rabbitconf['users'] {
      vmbuildhelper::rabbitmq::users { 'blah':
        users   => $rabbitconf['users'],
        require => Service['rabbitmq-server']
      }
    }

    if $rabbitconf['user_permissions'] {
      vmbuildhelper::rabbitmq::user_permissions { 'blah':
        user_permissions => $rabbitconf['user_permissions'],
        require          => Service['rabbitmq-server']
      }
    }
  }
}