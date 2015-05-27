class vmbuildhelper::nfs {
  if $nfsconf == undef {
    $nfsconf = hiera_hash('nfs',{ })
  }

  if count($nfsconf) > 0 {
    create_resources(vmbuildhelper::nfs::mount, $nfsconf)
  }
}