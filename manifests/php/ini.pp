# Helps define a ini entry in an ini file within /etc/php.d

define vmbuildhelper::php::ini (
  $ini_filename = 'tamble_custom.ini',
  $entry,
  $value  = '',
  $ensure = present
) {

  $target_dir  = '/etc/php.d'
  $target_file = "${target_dir}/${ini_filename}"

  if ! defined(File[$target_file]) {
    file { $target_file:
      replace => no,
      ensure  => present,
      require => Class['php'],
      notify  => Service['httpd']
    }
  }

  php::augeas { "${entry}-${value}" :
    target  => $target_file,
    entry   => $entry,
    value   => $value,
    ensure  => $ensure,
    require => File[$target_file],
    notify  => Service['httpd'],
  }

}