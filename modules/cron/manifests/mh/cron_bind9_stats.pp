class cron::bind9_stats inherits cron {
  cron { bind9_stats:
    user    => root,
    # puppet currently doesn't support this syntax, TBD make this work
    #   minute  => "3-58/5",
    minute  => [3,8,13,18,23,28,33,38,43,48,53,58],
    command => "/bin/bash -c 'PATH=/usr/local/sbin:/usr/sbin:/bin:/usr/sbin ; rndc stats ; /bin/sleep 10 ; /bin/mv /var/named/chroot/var/named/data/named_stats.txt /tmp'"
  }
}
