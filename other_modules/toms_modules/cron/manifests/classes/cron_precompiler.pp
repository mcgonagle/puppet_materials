class cron::cron_precompiler inherits cron {

 manhunt_cron_file { precompiler:
    script_name => "precompiler",
  }
  cron { precompiler:
    ensure => present,
    command => "$cron_dir/precompiler | $cron_dir/mailif -t $monitor_mail \"$hostname precompiler\"",
    user    => root,
    hour    => 4,
    minute  => 30,
    require => Manhunt_cron_file [ precompiler ],
  }

}
