class cron::cron_v4Notify inherits cron {

  include cron_v4notify_scripts

  # opts are "daily/weekly" "# messages (o for all)"  "email for testing. (or REAL to actually run it)"
  $opts="daily 0 REAL"
  $mailnotify ="$monitor_mail,sfrattura@online-buddies.com"
  $ensure = "present"
  cron { "v4Notify daily 0":
    command => "$cron_dir/v4Notify.sh $opts 0 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 09,
    minute  => 00,
    weekday => [ 2,4,6 ],
    ensure => $ensure,
  }
  cron { "v4Notify daily 1":
    command => "$cron_dir/v4Notify.sh $opts 1 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 09,
    minute  => 00,
    weekday => [ 1,3,5 ],
    ensure => $ensure,
  }

  cron { "v4Notify daily 2":
    command => "$cron_dir/v4Notify.sh $opts 2 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 11,
    minute  => 00,
    weekday => [ 2,4,6 ],
    ensure => $ensure,
  }
  cron { "v4Notify daily 3":
    command => "$cron_dir/v4Notify.sh $opts 3 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 11,
    minute  => 00,
    weekday => [ 1,3,5 ],
    ensure => $ensure,
  }
  cron { "v4Notify daily 4":
    command => "$cron_dir/v4Notify.sh $opts 4 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 13,
    minute  => 00,
    weekday => [ 2,4,6 ],
    ensure => $ensure,
  }
  cron { "v4Notify daily 5":
    command => "$cron_dir/v4Notify.sh $opts 5 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 13,
    minute  => 00,
    weekday => [ 1,3,5 ],
    ensure => $ensure,
  }

  cron { "v4Notify daily 6":
    command => "$cron_dir/v4Notify.sh $opts 6 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 15,
    minute  => 00,
    weekday => [ 2,4,6 ],
    ensure => $ensure,
  }
  cron { "v4Notify daily 7":
    command => "$cron_dir/v4Notify.sh $opts 7 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 15,
    minute  => 00,
    weekday => [ 1,3,5 ],
    ensure => $ensure,
  }
  cron { "v4Notify daily 8":
    command => "$cron_dir/v4Notify.sh $opts 8 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 17,
    minute  => 00,
    weekday => [ 2,4,6 ],
    ensure => $ensure,
  }
  cron { "v4Notify daily 9":
    command => "$cron_dir/v4Notify.sh $opts 9 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 17,
    minute  => 00,
    weekday => [ 1,3,5 ],
    ensure => $ensure,
  }
}
