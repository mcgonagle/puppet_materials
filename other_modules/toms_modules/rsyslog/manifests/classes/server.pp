class rsyslog::server inherits rsyslog {
  augeas{ "/etc/sysconfig/rsyslog":
  context => "/files/etc/sysconfig/rsyslog",
  changes => [
    "set dir[. = 'SYSLOGD_OPTIONS' ] -m 0 -r -t514",
    ],
  }#end of augeas export bar

 file{"/etc/rsyslog.d/rsyslog-server.conf":
  content => '#rsyslogd server log directives
:programname, isequal, "puppetd" /var/log/puppet/puppetd.log
:fromhost-ip,startswith,"192.168" ?RemoteFromHost
& ~',
  owner => "root", group => "root", mode => "0644",
  notify => Service["rsyslog"], }
}
