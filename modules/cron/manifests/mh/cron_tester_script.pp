class cron::cron_tester_script inherits cron {
  manhunt_cron_file { cron_tester_script:
    script_name => "cron_tester.sh",
  }
}
