class cron::cron_csr_update inherits cron {
  manhunt_cron_file { csr_update:
    script_name => "csr_update",
  }
  cron { csr_update:
    ensure => present,
    command => "$cron_dir/csr_update | $cron_dir/mailif -t $monitor_mail \"$hostname csr update\"",
    user    => root,
    minute  => '*/10',
    require => Manhunt_cron_file [ csr_update ],
  }
}
