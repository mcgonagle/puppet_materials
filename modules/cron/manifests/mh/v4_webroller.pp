class cron::mh::v4_webroller {
  cron::manhunt_cron_item { v4_webroller_hourly:
    user    => logs,
    minute  => generate("/bin/sh", "-c", "echo $ipaddress | echo `cut -d. -f 4` % 60 | bc"),
  }
}
