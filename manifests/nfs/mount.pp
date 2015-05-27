define vmbuildhelper::nfs::mount (
  $mountpoint = $title,
  $ensure = 'mounted',
  $atboot,
  $remounts,
  $device,
  $fstype = 'nfs',
  $options = 'defaults'
){
  package { 'nfs_package':
    ensure => installed,
    name   => 'nfs-utils',
  }

  if ! defined(File[$mountpoint]) {
    exec { "/bin/mkdir -p ${mountpoint}":
      creates => "${params['home']}"
    }
    file { $mountpoint:
      ensure  => 'directory',
      mode    => '2775',
      group   => 'wheel',
      require => Exec["/bin/mkdir -p ${mountpoint}"]
    }
  } else {
    File<| title == $mountpoint |> {
      group  => "wheel",
      mode   => '2775',
    }
  }

  mount { $mountpoint:
    ensure   => $ensure,
    atboot   => $atboot,
    remounts => $remounts,
    device   => $device,
    fstype   => $fstype,
    options  => $options,
    require  => File[$mountpoint]
  }
}

