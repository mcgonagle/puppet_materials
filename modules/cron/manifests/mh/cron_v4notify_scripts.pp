class cron::cron_v4notify_scripts inherits cron {
  manhunt_cron_file { v4Notify_SMS:
    script_name => "v4Notify_SMS.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }

  manhunt_cron_file { v4Notify:
    script_name => "v4Notify.sh",
    require => File [ "/etc/$orgname/source.sh" ],
  }
}
