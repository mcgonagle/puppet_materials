class cron::cron_sync_puppet inherits cron {
  cron { rsync_puppet:
    ensure => present,
    command => "rsync -a ovulator01:/etc/puppet/manifests /etc/puppet/",
    user    => care,
    hour    => 4,
    minute  => 0,
  }
}
