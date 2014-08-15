class cron::cron_v4Notify_SMS inherits cron {
  include cron_v4notify_scripts
  # opts are "daily/weekly" "# messages (o for all)"  "email for testing. (or REAL to actually run it)"
  $opts="daily 0 REAL"
  $mailnotify ="$monitor_mail,sfrattura@online-buddies.com"

  cron { "v4Notify_SMS daily":
    command => "$cron_dir/v4Notify_SMS.sh $opts | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => care,
    hour    => 12,
    minute  => 00,
    ensure => present,
  }
}
