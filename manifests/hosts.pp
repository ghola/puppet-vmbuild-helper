class vmbuildhelper::hosts {
  if $hostsconf == undef {
    $hostsconf  = hiera_hash('hosts',{ })
  }

  class { "::hosts":
    host_entries => $hostsconf
  }
}