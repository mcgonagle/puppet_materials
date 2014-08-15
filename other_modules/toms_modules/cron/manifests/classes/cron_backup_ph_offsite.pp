class cron::cron_backup_ph_offsite inherits cron {
  manhunt_cron_item { backup_directory:
    user    => care,
    weekday => [ 3, 6],
    hour    => 3,
    minute  => 30,
    opts    => "photos tera-bactyl02 /var/backup/photos/nfs0[1-7] --bwlimit=300",
  }
}
