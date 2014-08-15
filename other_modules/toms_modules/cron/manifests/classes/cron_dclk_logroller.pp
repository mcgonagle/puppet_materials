class cron::cron_dclk_logroller inherits cron {
 # Raw Logfiles are Zipped after this many days
  $raw_retention_days = $hostname ? {
    default => '7'
  }

  # Zipped Logfiles are deleted after this many days
  $zip_retention_days = $hostname ? {
    dartrpis01 => "30",
    default => '60'
  }

  manhunt_cron_item { dclk_logroller:
    user    => dclk,
    hour    => 5,
    minute  => 15,
    opts    => "$raw_retention_days $zip_retention_days",
    mailnotify => "$monitor_mail,kpanacy@online-buddies.com",
  }
}

