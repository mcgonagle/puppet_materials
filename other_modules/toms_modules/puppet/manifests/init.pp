# Class: puppet
#
# This class installs and makes sure that a puppet client is configured.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  include puppet
#

import "classes/*.pp"
class puppet {
   package { "puppet": ensure => latest }

  file {"/etc/init.d/puppet":
	  source => "puppet:///modules/puppet/puppet",
	  owner => "root", group => "root", mode => "0755"; }

  file {"/etc/puppet/puppet.conf":
	  source => ["puppet:///modules/puppet/puppet.conf.${hostname}",
		     "puppet:///modules/puppet/puppet.conf.${role}",
		     "puppet:///modules/puppet/puppet.conf.${zone}",
		     "puppet:///modules/puppet/puppet.conf"],
	  owner => "root", group => "root", mode => "0644",
	  require => Package["puppet"], }

  nagmon::service {"puppet":
    ensure => running,
    enable => true,
    pid_file => "/var/run/puppet/puppetd.pid",
    init_script => "/etc/init.d/puppet",
    warn => "1:1",
    critical => "1:1",
    nrpe_parameter => "-C puppetd",
 	  require => [Package["puppet"],
                File["/etc/init.d/puppet"], 
                File["/etc/puppet/puppet.conf"]], }

  @@nagios_service { "check_last_puppet_run ${hostname}":
  	ensure => present,
  	use => "generic-service",
  	host_name => "${hostname}",
  	check_command => "check_nrpe!check_last_puppet_run",
  	name => "check_last_puppet_run ${hostname}",
  	service_description => "check_last_puppet_run",
  	target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  	require => File["/etc/nagios/services"],
  	notify => Service["nagios"], }

}#end of class puppet
