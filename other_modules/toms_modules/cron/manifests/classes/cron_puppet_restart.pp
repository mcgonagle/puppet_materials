class cron::puppet_restart inherits cron {
  cron { puppet_restart:
    command => "/bin/bash -c '[ -d /proc/`cat /var/run/puppet/puppetd.pid` ] || /sbin/service puppet start 2>&1 >/dev/null'",
    user    => root,
    minute  => '*/15'
  }
}
