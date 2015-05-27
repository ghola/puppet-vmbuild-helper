class vmbuildhelper::rubygems {
  if $gemsconf == undef {
    $gemsconf = hiera_array('rubygems',[])
  }

  if count($gemsconf) > 0 {
    package { $gemsconf:
      ensure   => 'installed',
      provider => 'gem',
    }
  }
}