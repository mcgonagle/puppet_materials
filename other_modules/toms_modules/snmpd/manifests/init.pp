# Class: snmpd
#
# Manages snmp server.
# Include it to install and run snmp with default settings
#
# Usage:
# include snmpd

import "classes/*.pp"

class snmpd {
    $monitor_mail = extlookup("monitor_mail") 
    package { "net-snmp": ensure => latest }
    package { "net-snmp-utils": ensure => latest }

    file { "/etc/snmp/snmpd.conf":
      content => template("snmpd/snmpd.conf.erb"),
 	    owner => "root", group => "root", mode => "0644",
	    require => [ Package["net-snmp"], Package["net-snmp-utils"]], }

    file { "/etc/snmp/snmpd.options":
 	    content => 'OPTIONS="-Ls3 -Lf /var/log/snmpd.log -p /var/run/snmpd.pid -a"',
 	    owner => "root", group => "root", mode => "0644",
	    require => File["/etc/snmp/snmpd.conf"], }

    file { "/etc/sysconfig/snmpd.options":
	    ensure => "/etc/snmp/snmpd.options",
 	    owner => "root", group => "root", mode => "0644",
	    require => File["/etc/snmp/snmpd.options"], }

    nagmon::service {"snmpd":
	    enable => true,
	    ensure => running,
      pid_file => "/var/run/snmpd.pid",
      init_script => "/etc/init.d/snmpd",
      warn => "1:1",
      critical => "1:1",
      nrpe_parameter => "-C snmpd",  
	    subscribe => [ File["/etc/snmp/snmpd.conf"], 
                     File["/etc/snmp/snmpd.options"],
                     File["/etc/sysconfig/snmpd.options"] ],
	    require => [ File["/etc/snmp/snmpd.options"], Package["net-snmp"] ] }
}#end of class snmpd
