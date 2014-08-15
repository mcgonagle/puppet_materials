class cron::cron_pushlogs inherits cron {
  manhunt_cron_file { rotate_backup:
    script_name => "bkuprotate.sh",
  }
  cron { rotate_backup:
    ensure => present,
    command => "$cron_dir/bkuprotate.sh",
    user    => care,
    hour    => 6,
    minute  => 45,
    require => [ Manhunt_cron_file [ rotate_backup ]],
  }
}
