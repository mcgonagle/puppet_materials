class cron::creativesync inherits cron {
  include manhunt_user_keys
  include manhunt_cron_utils

  file { "$cron_dir/http_check.sh":
    ensure => absent,
  }

  file { "$cron_dir/hostchecker.pl":
    source => "puppet://$servername/files/$orgname/tools/hostchecker.pl",
    mode => 755, owner => root, group => root,
  }

  manhunt_cron_file { creativesync:
    script_name => "creativesync",
  }

  cron { "creativesync full":
    ensure => $hostname ? {
      cron02 => present,
      default => absent,
    },
    command => "$cron_dir/creativesync full | $cron_dir/mailif -t $monitor_mail \"$hostname creative content full-mode sync to hosts\"",
    user    => deploy,
    hour    => $hostname ? { default => '3' },
    minute  => $hostname ? { default => '15' },
    require => [ Manhunt_cron_file [ creativesync ],
                 Manhunt_cron_file [ mailif ] ],
  }

  cron { "creativesync delta":
    ensure => $hostname ? {
      cron02 => present,
      default => absent,
    },
    command => "$cron_dir/creativesync delta | $cron_dir/mailif -t $monitor_mail \"$hostname creative content batch-mode sync to hosts\"",
    user    => deploy,
    hour    => [0,1,2,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],
    minute  => [0,15,30,45],
    require => [ Cron [ "creativesync full" ],
                 Manhunt_cron_file [ creativesync ],
                 Manhunt_cron_file [ mailif ] ],
  }
  manhunt_host_keys { wwwhosts: }

}
