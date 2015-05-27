class vmbuildhelper::firewall {
  if $firewallconf == undef {
    $firewallconf = hiera_hash('iptables',{ })
  }

  create_resources(iptables::rule, $firewallconf)
}