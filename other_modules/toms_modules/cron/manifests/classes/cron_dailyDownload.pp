class cron::cron_dailyDownload inherits cron {
  cron { "DailyDownloadLauncher.sh":
    command => "rm /var/log/dailydownload/current ; /usr/local/manhunt/cron/DailyDownloadLauncher.sh 2>&1 1>> /var/log/dailydownload/current",
    user    => care,
    hour    => 07,
    minute  => 00,
    require => File [ "/etc/$orgname/source.sh" ],
    ensure => present,
  }
}
