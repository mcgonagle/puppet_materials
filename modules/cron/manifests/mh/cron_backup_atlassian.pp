class cron::cron_backup_atlassian inherits cron {
  include manhunt_user_keys
  $atlassian_host = "atlas00.svc.cambridge.manhunt.net"
  $atlassian_dir = "/data01"
  $atlassian_appdirs = "confluence-data jira-data"

  manhunt_cron_item { backup_atlassian:
    user    => care,
    hour    => 5,
    minute  => 25,
    opts    => "$atlassian_host $atlassian_dir $atlassian_appdirs",
  }
}
