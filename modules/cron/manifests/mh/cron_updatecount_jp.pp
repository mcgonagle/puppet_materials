class cron::cron_updatecount_jp inherits cron {

  manhunt_cron_file { updatecount:
    script_name => "updatecount",
  }
  cron { updatecount:
    ensure => present,
    command => "$cron_dir/updatecount | $cron_dir/mailif -t $monitor_mail \"$hostname update count\"",
    user    => root,
    minute  => '*/20',
    require => Manhunt_cron_file [ updatecount ],
  }

}
