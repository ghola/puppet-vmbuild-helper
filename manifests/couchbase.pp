class vmbuildhelper::couchbase {
  if $couchconf == undef {
    $couchconf = hiera_hash('couchbase',{ })
  }

  if count($couchconf) > 0 {
    class { '::couchbase':
      size     => $couchconf['size'],
      user     => $couchconf['user'],
      password => $couchconf['password'],
      version  => $couchconf['version'],
      edition  => $couchconf['edition'],
      ensure   => $couchconf['ensure'],
    }

    if $couchconf['buckets'] {
      create_resources(couchbase::bucket, $couchconf['buckets'])
    }

    if $couchconf['clientlibs'] {
      create_resources(couchbase::client, $couchconf['clientlibs'])
    }

    if defined(Php::Pecl::Module['pecl-couchbase']) {
      Class['Couchbase'] -> Couchbase::Client <| |> -> Php::Pecl::Module['pecl-couchbase']
    } else {
      Class['Couchbase'] -> Couchbase::Client <| |> -> Php::Pecl::Module['couchbase']
    }
  }
}