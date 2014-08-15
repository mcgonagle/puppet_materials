class cron::cron_manhuntdaily_rss inherits cron {

  manhunt_cron_file { manhuntdaily_rss_contents:
    script_name => "manhuntdaily_rss_contents.sh",
  }

  cron { manhuntdaily_rss_contents:
    ensure => present,
    command => "$cron_dir/manhuntdaily_rss_contents.sh",
    user    => care,
    minute  => '*/30',
    require => Manhunt_cron_file [ manhuntdaily_rss_contents ],
  }
}
