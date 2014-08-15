class cron::cron_v4Notify_SMS_weekly inherits cron {
  include cron_v4notify_scripts
  # opts are "daily/weekly" "# messages (o for all)"  "email for testing. (or REAL to actually run it)"
  $opts="weekly 0 REAL"
  $mailnotify ="$monitor_mail,sfrattura@online-buddies.com"

  cron { "v4Notify_SMS weekly":
    command => "$cron_dir/v4Notify_SMS.sh $opts | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 12,
    minute  => 00,
    weekday => [ 6 ],
    ensure => present,
  }
}
