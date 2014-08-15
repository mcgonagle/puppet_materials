#common class provides a common module and namespace primarily for 'common'
import "defines/*.pp"
class common {
 User { require => Class["yumrepos"] }
 Package { require => Class["users::it_users"] }
 include users::it_users

 #include jenkins

 include hosts
 include bash
 include root
 include yumrepos
 include ssh
 #include java::sun
 include sun-java
 include puppet
 include postfix::client
 include yum::conf
 include rstatd
 include logrotate
 include rsync
 include ntp
 include iptables
 include vim

 if ($hostname != "lrmedia01") { include autofs::home }
 #needs to be re-modelled
 include snmpd
 include sudoers

 if ($hostname != "lrmedia01") { include nagios::client }

 if ($zone != "wf") { include nagios::client }
 
 include ganglia::client
 include mcollective::client
 include mcollective::plugin
 include func::minion
 include supervisor::client
 include munin::client
 include ocsinventory::client
 include monit::client

 #include serverdensity::agent
 #include zenoss::client

}#end of common class
