class cron::cron_UnpaidJoinsMail inherits cron {
  manhunt_cron_file { unpaid_joins_mail:
    script_name => "UnpaidJoinsMail.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }
  # the 1 means debug mode, remove it entirely to actually run
  cron { unpaid_joins_mail_schedule:
    ensure => present,
    command => "$cron_dir/UnpaidJoinsMail.sh > /home/care/UnpaidJoinsMail_cron.log 2>&1",
    user    => care,
    hour    => 2,
    minute  => 00,
    require => Manhunt_cron_file [ unpaid_joins_mail ],
  }
}
