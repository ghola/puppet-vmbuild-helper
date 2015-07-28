class vmbuildhelper::users {
  if $usersconf == undef {
    $usersconf = hiera_hash('users',{ })
  }

  create_resources(user, $usersconf)

# ensure home directories are created with proper rights and group
# and that the bash skel files are copied
  if count($usersconf) > 0 {
    $usersconf.each |$username, $params| {
        if $params['password'] {
          $password = $params['password']
          exec { "set password for $username":
            command => "/bin/echo \"$username:$password\" | /usr/sbin/chpasswd",
            require => User[$username],
          }
        }

        if $params['home'] {
          if ! defined(File[$params['home']]) {
            exec { "/bin/mkdir -p ${params['home']}":
              creates => "${params['home']}"
            }
            file { $params['home']:
              ensure  => 'directory',
              mode    => '2775',
              group   => 'wheel',
              require => Exec["/bin/mkdir -p ${params['home']}"]
            }
          } else {
            $home = $params['home'];
            File <| title == $home |> {
              group  => 'wheel',
              mode   => '2775',
            }
          }

          $files = ['.bashrc','.bash_profile','.bash_logout']

          $files.each |$key, $file| {
              file { "${params['home']}/${file}":
                ensure  => 'present',
                source  => "/etc/skel/${file}",
                group   => 'wheel',
                owner   => $username,
                mode    => 0664,
                require => File[$params['home']]
              }
            }
        }
      }
  }
}