class cron::cron_getRulebase inherits cron {
  manhunt_cron_item { "getRulebase.sh":
    user   => "care",
    minute => "*/50",
  }
}
