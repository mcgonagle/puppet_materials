class cron::cron_v4Notify_weekly inherits cron {

 include cron_v4notify_scripts
  # opts are "daily/weekly" "# messages (o for all)"  "email for testing. (or REAL to actually run it)"
  $opts       ="weekly 0 REAL"
  $mailnotify ="$monitor_mail,sfrattura@online-buddies.com"
  $ensure     = "present"
  cron { "v4Notify weekly 0":
    command => "$cron_dir/v4Notify.sh $opts 0 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 8,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }

  cron { "v4Notify weekly 1":
    command => "$cron_dir/v4Notify.sh $opts 1 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 9,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }
  cron { "v4Notify weekly 2":
    command => "$cron_dir/v4Notify.sh $opts 2 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 10,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }

 cron { "v4Notify weekly 3":
    command => "$cron_dir/v4Notify.sh $opts 3 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 11,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }
  cron { "v4Notify weekly 4":
    command => "$cron_dir/v4Notify.sh $opts 4 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 12,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }
  cron { "v4Notify weekly 5":
    command => "$cron_dir/v4Notify.sh $opts 5 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 14,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }
 cron { "v4Notify weekly 6":
    command => "$cron_dir/v4Notify.sh $opts 6 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 15,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }
  cron { "v4Notify weekly 7":
    command => "$cron_dir/v4Notify.sh $opts 7 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 16,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }
  cron { "v4Notify weekly 8":
    command => "$cron_dir/v4Notify.sh $opts 8 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 17,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }

  cron { "v4Notify weekly 9":
    command => "$cron_dir/v4Notify.sh $opts 9 | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 18,
    minute  => 00,
    weekday => [ 0 ],
    ensure => $ensure,
  }
}
