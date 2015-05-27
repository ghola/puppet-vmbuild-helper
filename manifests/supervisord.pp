class vmbuildhelper::supervisord {
  class{ '::supervisord':
    umask                => '002',
    inet_server          => true,
    inet_server_hostname => '*',
    executable           => '/usr/bin/supervisord',
    executable_ctl       => '/usr/bin/supervisorctl'
  }
}