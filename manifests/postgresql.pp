class vmbuildhelper::postgresql {
  if $psqlconf == undef {
    $psqlconf = hiera_hash('postgresql',{ })
  }

  class { '::postgresql::globals':
    encoding            => 'UTF-8',
    manage_package_repo => true,
    version             => '9.4'
  }->
  class { '::postgresql::server':
    ip_mask_allow_all_users    => '0.0.0.0/0',
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    listen_addresses           => '*',
  }

  if $psqlconf['databases'] {
    create_resources('postgresql::server::db', $psqlconf['databases'])
  }
}