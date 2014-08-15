class cron::cron_netstat_inspector inherits cron {

  # How many times should the inspector run?
  $run_times = $hostname ? {
    db06 => "12",
  }

  # How many seconds should it sleep between runs?
  $sleep_seconds = $hostname ? {
    db06 => "300",
  }

  manhunt_cron_item { netstat_inspector:
    user    => root,
    hour    => 4,
    minute  => 15,
    opts    => "$run_times $sleep_seconds",
  }

}
