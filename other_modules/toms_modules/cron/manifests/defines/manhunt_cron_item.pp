# We use this function to copy and execute scripts through cron
define cron::manhunt_cron_item (
  $user,
  #   Unix username to run under

  $weekday = "0-6",
  #   Day(s) of week 0=Sun, 6=Sat.  *NOTE* do NOT specify asterisk, if you want
  #   every, leave at default

  $hour = "0-23",
  #   Hour(s) of day.  Again, do NOT specify asterisk if you want to run every hour

  $minute,
  #   Minute of the specified hour(s)

  $mailnotify = $monitor_mail,
  #   Email to send any output that appears on stdout

  $opts = "",
  #   Command-line options to pass to the script

  $ensure = present
  #   Set to 'absent' if you want to cancel a cron
  ) {
  manhunt_cron_file { $name:
    script_name => $name,
  }

  cron { $name:
    command => "$cron_dir/$name $opts | $cron_dir/mailif -t $mailnotify \"$hostname $name\"",
    user    => $user,
    weekday => $weekday,
    hour    => $hour,
    minute  => $minute,
    ensure => $ensure,
    require => [ Manhunt_cron_file [ $name ],
                 Manhunt_cron_file [ mailif ] ],
  }
}
