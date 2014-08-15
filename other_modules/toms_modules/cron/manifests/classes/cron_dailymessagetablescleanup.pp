class cron::cron_dailymessagetablescleanup inherits cron {
  manhunt_cron_file { dailyMessageTablesCleanUp:
    script_name => "dailyMessageTablesCleanUp",
  }

  cron { dailyMessageTablesCleanUp:
    ensure => present,
    command => "${cron::params::cron_dir}/dailyMessageTablesCleanUp | ${cron::params::cron_dir}/mailif -t ${monitor_mail} \"${hostname} daily messages table cleanup\"",
    user    => root,
    hour    => 6,
    minute  => 05,
    require => [ Manhunt_cron_file [ dailyMessageTablesCleanUp ],
                 Manhunt_cron_file [ mailif ] ], 
  }
}
