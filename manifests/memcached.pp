class vmbuildhelper::memcached {
  if $memconf == undef {
    $memconf = hiera_hash('memcached',{ })
  }

  if count($memconf) > 0 {
    class { '::memcached':
      cachesize => $memconf['cachesize'],
      port      => $memconf['port'],
      maxconn   => $memconf['maxconn'],
      options   => $memconf['options'],
    }
  }
}