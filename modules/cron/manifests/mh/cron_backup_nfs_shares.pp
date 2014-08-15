class cron::puppet_restart inherits cron {
  include manhunt_user_keys

  manhunt_cron_item { backup_nfs_shares:
    user    => care,
    hour    => '*/6',
    minute  => 25,

    # jp and gallery backup shut off 8/17-09
    ensure => absent,
  }
  #   manhunt_host_keys { nfshosts: }

}
