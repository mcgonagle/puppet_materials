class cron::cron_backup_subversion inherits cron {

  include cron_rotate_subversion

  manhunt_cron_item { backup_subversion:
    user    => care,
    hour    => [0,1,2,3,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],
    minute  => 10,
    opts    => repo02,
  }
}
