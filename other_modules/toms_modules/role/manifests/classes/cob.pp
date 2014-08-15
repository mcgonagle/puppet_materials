class role::cob inherits role {

 
 yumrepo{"cobbler_bootstrap":
        baseurl => "file:///etc/puppet/rpms",
        descr => "local cobbler bootstrap repo",
        enabled => "0",
	gpgcheck => "0",}
 

  #include extlookup
  include yumrepos::remi::disabled
  
  include cobbler_server
  include puppet::server

  #include ganglia::server
  include munin::server
  
  include activemq::server
  include mcollective::server
  include func::server
  include splunk::server

  include nagios::server
  include ocsinventory::server
  #include zenoss::server
  include mysqlmonitor::server
  include mysqlmonitor::agent::queryanalyzer
  #include webistrano

  #include smartfox
  include rpm-build
  include rsnapshot
 
}
