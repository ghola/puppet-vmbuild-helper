class vmbuildhelper::yum {
  if $yumconf == undef {
    $yumconf = hiera_hash('yum',{ })
  }
  if count($yumconf) > 0 {
    class { '::yum':
      extrarepo => $yumconf['repos']
    }
  }
}