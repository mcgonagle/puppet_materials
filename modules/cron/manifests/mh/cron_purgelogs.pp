class cron::cron_purgelogs inherits cron {
  file { "/var/log/masterpurge.log":
    ensure => present,
    mode => 640, owner => care, group => wheel,
  }
  manhunt_cron_file { masterpurge:
    script_name => "masterpurge.sh",
    mode    => 550,  owner => care,
    require => File [ "/var/log/masterpurge.log" ],
  }
  cron { masterpurge:
    ensure => present,
    command => "$cron_dir/masterpurge.sh",
    user    => care,
    minute  => 30,
    hour        => '*/2',
  }
}
