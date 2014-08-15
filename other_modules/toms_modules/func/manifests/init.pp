import "classes/*.pp"
class func {
  include puppet::client

  package{"func": ensure => latest}
  package{"certmaster": ensure => latest}
  package{"smolt": ensure => latest}

  file { "/etc/certmaster/minion.conf":
   content => template("func/minions/certmaster/minion.conf.erb"),
   owner => "root", group => "root", mode => "0644",
   require => Package["certmaster"],
   notify => Service["certmaster"], }

  file { "/etc/func/minion.conf":
   content => template("func/minions/func/minion.conf.erb"),
   owner => "root", group => "root", mode => "0644",
   require => Package["func"],
   notify => Service["funcd"], }

    file { "/var/lib/puppet/ssl/func":
      ensure => directory,
      owner => "puppet", group => "puppet", mode => "0555",
      require => Class["puppet::client"], }

    file { "/var/lib/puppet/ssl/func/ca.cert":
      ensure => "/var/lib/puppet/ssl/certs/ca.pem",
      owner => "root", group => "root", mode => "0444",
      require => File["/var/lib/puppet/ssl/func"],
      notify => Service["funcd"], }

    file { "/var/lib/puppet/ssl/func/${fqdn}.cert":
      ensure => "/var/lib/puppet/ssl/certs/${fqdn}.pem",
      owner => "root", group => "root", mode => "0444",
      require => File["/var/lib/puppet/ssl/func/ca.cert"],
      notify => Service["funcd"], }

    file { "/var/lib/puppet/ssl/func/${fqdn}.csr":
      ensure => "/var/lib/puppet/ssl/certificate_requests/${fqdn}.pem",
      owner => "root", group => "root", mode => "0444",
      require => File["/var/lib/puppet/ssl/func/${fqdn}.cert"],
      notify => Service["funcd"], }

    file { "/var/lib/puppet/ssl/func/${fqdn}.pem":
      ensure => "/var/lib/puppet/ssl/private_keys/${fqdn}.pem",
      owner => "root", group => "root", mode => "0444",
      require => File["/var/lib/puppet/ssl/func/${fqdn}.csr"],
      notify => Service["funcd"], }
 
  file {"/usr/lib/python2.4/site-packages/func/minion/modules/nagios-check.py":
   source => "puppet:///modules/func/nagios-check.py",
   owner => "root", group => "root", mode => "0644",
   notify => Service["funcd"], }
   
  nagmon::service{"funcd":
   enable => true,
   ensure => running, 
	 pid_file => "/var/run/funcd.pid",
	 init_script => "/etc/init.d/funcd", 
   warn => "1:1",
   critical => "1:1",
   nrpe_parameter => "-C funcd",
   require => [Package["func"], 
              File["/etc/func/minion.conf"]],}

  nagmon::service { "certmaster":
   enable => true,
   ensure => running, 
	 pid_file => "/var/run/certmaster.pid",
	 init_script => "/etc/init.d/certmaster", 
   warn => "1:1",
   critical => "1:1",
   nrpe_parameter => "-C certmaster", 
   require => [Package["certmaster"], 
              File["/etc/certmaster/minion.conf"]],}

}#end of class func
