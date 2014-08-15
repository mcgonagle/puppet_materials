class cron::cron_PromoSubsExpireMail inherits cron {

  manhunt_cron_file { subs_expire_mail:
    script_name => "SubsExpireMail.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }
  manhunt_cron_file { promos_expire_mail:
    script_name => "PromosExpireMail.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }

  # the 1 means debug mode, remove it entirely to actually run
  cron { subs_expire_mail_schedule:
    ensure => present,
    command => "$cron_dir/SubsExpireMail.sh 1 > /home/care/SubsExpireMail_cron.log 2>&1",
    user    => care,
    hour    => 2,
    minute  => 05,
    require => Manhunt_cron_file [ subs_expire_mail ],
  }
  cron { promos_expire_mail_schedule:
    ensure => present,
    command => "$cron_dir/PromosExpireMail.sh 1 > /home/care/PromosExpireMail_cron.log 2>&1",
    user    => care,
    hour    => 9,
    minute  => 18,
    require => Manhunt_cron_file [ promos_expire_mail ],
  }

}
