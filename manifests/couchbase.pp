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
    }

    if $couchconf['buckets'] {
      create_resources(couchbase::bucket, $couchconf['buckets'])
    }

    if $couchconf['clientlibs'] {
      create_resources(couchbase::client, $couchconf['clientlibs'])
    }

    Class['Couchbase'] -> Couchbase::Client <| |> -> Php::Pecl::Module['couchbase']
  }
}