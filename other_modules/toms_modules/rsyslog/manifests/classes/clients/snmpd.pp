class rsyslog::client::snmpd inherits rsyslog::client {
 file{"/etc/rsyslog.d/snmpd.conf":
  content => ':programname, isequal, "snmpd" /var/log/snmpd.log
&~',
  owner => "root", group => "root", mode => "0644",
  notify => Service["rsyslog"], }
 
}
