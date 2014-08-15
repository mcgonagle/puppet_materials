class cron::cron_dbsnap inherits cron {

  $snapsize = $hostname ? {
    itdb01 => "5G", itdb02 => "5G", itdb03 => "5G", itdb04 => "5G",
    default => "20G"
  }

  manhunt_cron_file { dbsnap:
    script_name => "dbsnap.sh",
  }

  cron { dbsnap:
    command => "$cron_dir/dbsnap.sh agent 2001 $snapsize 5 | $cron_dir/mailif -t $monitor_mail \"dbsnap\"",
    user    => root,
    hour    => [ 2,8,13,17,21 ],
    minute  => 20,
    require => [ Manhunt_cron_file [ lvsnap ],
                 Manhunt_cron_file [ dbsnap ] ],
  }
}
