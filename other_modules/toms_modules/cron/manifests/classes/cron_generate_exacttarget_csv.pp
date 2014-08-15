class cron::cron_cleanup_script inherits cron {
  manhunt_cron_file { cleanup:
    script_name => "cleanup.sh",
  }
}
