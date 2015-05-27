class vmbuildhelper::dnsresolver {
  if $resolverconf == undef {
    $resolverconf = hiera_hash('resolver',{ })
  }

  file { '/etc/dhcp/dhclient-enter-hooks':
    content => "#!/bin/sh\nmake_resolv_conf() {\necho \"doing nothing to resolv.conf\"\n}",
    mode    => '0755'
  }->
  class { '::resolver' :
    dns_servers => $resolverconf['dns_servers'],
    search      => $resolverconf['search']
  }
}