class virtual_cron {
  @cron { "logrotate":
    ensure  => present,
    command => "echo \"we should rotate some logs\"",
    user    => "root",
    hour    => "0", 
    minute  => "0",
  } # @cron
} # class virtual_cron
