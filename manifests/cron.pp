class vmbuildhelper::cron {
  if $cronconf == undef {
    $cronconf = hiera_hash('cronjobs',{ })
  }

  if count($cronconf) > 0 {
    create_resources(cron::job, $cronconf)
  }
}