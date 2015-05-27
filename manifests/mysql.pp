class vmbuildhelper::mysql {
  if $mysqlconf == undef {
    $mysqlconf = hiera_hash('mysql',{ })
  }

  class { '::mysql::server':
    root_password    => $mysqlconf['root_password'],
    override_options => $mysqlconf['override_options']
  }

  if $mysqlconf['databases'] {
    create_resources('mysql::db', $mysqlconf['databases'])
  }

  if $mysqlconf['users'] {
    $mysqlconf['users'].each |$key, $value| {
mysql_user { "${value['user']}@${value['host']}" :
password_hash => $value['password_hash'],
require       => Class['mysql::server'],
}
}
}

if $mysqlconf['grants'] {
$mysqlconf['grants'].each |$key, $value| {
mysql_grant { "${value['user']}@${value['host']}/${value['table']}" :
privileges => $value['privileges'],
options    => $value['options'],
provider   => 'mysql',
user       => "${value['user']}@${value['host']}",
table      => $value['table'],
require    => Class['mysql::server'],
}
}
}

$provisionenv = hiera('provisionenv')

if $provisionenv == 'project' {
# Load the timezone tables
exec { 'mysql timezones':
command    => '/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | sudo /usr/bin/mysql -u root mysql',
notify     => Service['mysqld'],
user       => 'root'
}
}
}