class cron::cron_backup_v4media inherits cron {

  manhunt_cron_file { v4_media_backup:
    script_name => "v4_media_backup",
  }

  # obsolete media

  cron { v4_media_backup_shard1:
    ensure => absent,
    command => "$cron_dir/v4_media_backup media07.v4.waltham.manhunt.net data1",
    user    => care,
    #    weekday => [ 0, 1, 3, 5],
    hour   => 8,
    minute => 15,
    require => Manhunt_cron_file [ v4_media_backup ],
  }
  cron { v4_media_backup_shard2:
    ensure => absent,
    command => "$cron_dir/v4_media_backup media07.v4.waltham.manhunt.net data2",
    user    => care,
    #    weekday => [ 0, 2, 4, 6],
    hour   => 8,
    minute => 15,
    require => Manhunt_cron_file [ v4_media_backup ],
  }
  cron { v4_media_backup_shard3:
    ensure => absent,
    command => "$cron_dir/v4_media_backup media07.v4.waltham.manhunt.net data3",
    user    => care,
    #    weekday => [ 0, 1, 3, 5],
    hour   => 8,
    minute => 15,
    require => Manhunt_cron_file [ v4_media_backup ],
  }
  cron { v4_media_backup_shard4:
    ensure => absent,
    command => "$cron_dir/v4_media_backup media07.v4.waltham.manhunt.net data4",
    user    => care,
    #    weekday => [ 0, 2, 4, 6],
    hour   => 8,
    minute => 15,
    require => Manhunt_cron_file [ v4_media_backup ],
  }

}
