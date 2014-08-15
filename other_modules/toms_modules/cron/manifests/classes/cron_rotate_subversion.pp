class cron::cron_rotate_subversion inherits cron {
  manhunt_cron_item { svnroller:
    user    => care,
    hour    => 4,
    minute  => 15,
    opts    => "1 repo02",
  }
}
