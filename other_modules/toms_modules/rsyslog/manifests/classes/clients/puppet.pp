class rsyslog::client::puppet inherits rsyslog::client {
 file{"/etc/rsyslog.d/puppet.conf":
  content => '#:programname, isequal, "puppetd" /var/log/puppet/puppetd.log
:programname, isequal, "puppetd" @@${serverip}:514
#& ~',
  owner => "root", group => "root", mode => "0644",
  notify => Service["rsyslog"], }
 
}
