class vmbuildhelper::php {
  if $phpconf == undef {
    $phpconf = hiera_hash('php',{ })
  }

  Class['Php'] -> Class['Php::Devel'] -> Vmbuildhelper::Php::Ini <| |> -> Php::Module <| |> -> Php::Pear::Module <| |> -> Php::Pecl::Module <| |>

  class { '::php':
    version => $phpconf['version']
  }

  class { '::php::devel': }

  if $phpconf['modules']['php'] and is_hash($phpconf['modules']['php']) {
    create_resources(php::module, $phpconf['modules']['php'])
  }

  if $phpconf['modules']['pear'] and is_hash($phpconf['modules']['pear']) {
    create_resources(php::pear::module, $phpconf['modules']['pear'])
  }

  if $phpconf['modules']['pecl'] and is_hash($phpconf['modules']['pecl']) {
    create_resources(php::pecl::module, $phpconf['modules']['pecl'])

    $phpconf['modules']['pecl'].each |$key, $value| {

        if $value['use_package'] and $value['use_package'] == 'no' {

          if $key != 'xdebug' and $key != 'couchbase' and $key != 'pecl-memcached' and $key != 'memcached' {
            vmbuildhelper::php::ini { "${key}-extension":
              entry        => ".anon/extension",
              value        => "${key}.so",
              ini_filename => "${key}.ini",
              require      => Class["php"]
            }
          }

        # couchbase extension MUST laod after the json one, so i've put them in the same ini
          if $key == 'couchbase' {
            vmbuildhelper::php::ini { "${key}-extension":
              entry        => ".anon/extension[2]",
              value        => "${key}.so",
              ini_filename => "json.ini",
              require      => Class["php"]
            }
          }

        # memcached extension MUST load after the json one, so i've put them in the same ini
          if $key == 'memcached' {
            vmbuildhelper::php::ini { "${key}-extension":
              entry        => ".anon/extension[3]",
              value        => "${key}.so",
              ini_filename => "json.ini",
              require      => Class["php"]
            }
          }
        }
      }
  }

  if $phpconf['modules']['file'] and is_hash($phpconf['modules']['file']) {
    create_resources(vmbuildhelper::php::filemodule, $phpconf['modules']['file'])
  }

  if $phpconf['composer'] == true {
    class { '::composer': }
  }

  if $phpconf['ini'] and count($phpconf['ini']) > 0 {
    $phpconf['ini'].each |$key, $value| {
        vmbuildhelper::php::ini { $key:
          entry       => "TAMBLE/${key}",
          value       => $value
        }
      }
  }

  if $phpconf['modules']['pecl']['xdebug'] and is_hash($phpconf['modules']['pecl']['xdebug']) {
    vmbuildhelper::php::ini { 'xdebug-extension':
      entry        => ".anon/zend_extension",
      value        => "xdebug.so",
      ini_filename => "xdebug.ini",
      require      => Class["php"]
    }
  }
}
