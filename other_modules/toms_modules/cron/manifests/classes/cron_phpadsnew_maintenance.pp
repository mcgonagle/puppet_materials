class cron::cron_updatecount_jp inherits cron {
   cron { phpAdsNew_maintenance:
    ensure => present,
    command => "wget -q -O /dev/null http://$site_name/phpAdsNew/maintenance/maintenance.php | $cron_dir/mailif -t $monitor_mail \"$hostname phpAdsNew maint\"",
    user    => root,
    minute  => 0,
  }
}
