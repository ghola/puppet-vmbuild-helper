# Helper which runs the phing project build
define vmbuildhelper::phingbuild::build(
  $database
) {
  exec { "project-build-$name":
    command    => '/usr/bin/phing',
    user       => 'vagrant',
    cwd        => "/var/www/${::fqdn}",
    require    => Mysql::Db[$database]
  }
}