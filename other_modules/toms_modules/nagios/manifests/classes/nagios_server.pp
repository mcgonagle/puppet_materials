# Class: nagios::server
#
# Manages nagios software 
# Include it to install and run nagios with default settings
#
# Usage:
# include nagios::server

import "nagios_contacts/*.pp"
import "nagios_contactgroups/*.pp"
import "nagios_timeperiods/*.pp"
import "nagios_servicegroups/*.pp"
import "nagios_services/*.pp"
import "nagios_hostgroups/*.pp"
import "nagios_commands/*.pp"

class nagios::server inherits nagios { 
	$naginator_patch_file = "/usr/lib/ruby/site_ruby/1.8/puppet/provider/naginator.rb.patch"

  users::manage_user {"nagios":
        uid => "2003",
        gid => "2003",
        other_groups => ["sysadmin", "dba", "nagcmd" ],
        password => "*",
        shell => "/sbin/nologin",
        comment => "Nagios Monitor",
        manage_homedir => "false", }

   Package{ require => Users::Manage_user["nagios"] }
   package {"nagios": ensure => latest }
   package {"nagios-common": ensure => latest }
   package {"nagios-devel": ensure => latest }
   package {"nagios-plugins-http": ensure => latest }
   package {"nagios-plugins-ping": ensure => latest }
   package {"nagios-plugins-ssh": ensure => latest }

   include nagios::contact
   include nagios::contactgroup
   include nagios::timeperiod
   include nagios::servicegroup
   include nagios::command
   include nagios::pagerduty

   ##include nagios::hostgroup::server
   #include nagios::plugins::ping
   #include nagios::plugins::ifoperstatus
   #include nagios::plugins::check_nrpe  
  
   
   file {"/etc/httpd/conf.d/nagios.conf":
	    source => "puppet:///modules/nagios/httpd_nagios.conf",
	    owner => "root", group => "root", mode => "0644",
      require => Package[nagios], }

   file {"/etc/nagios/nagios.cfg":
	    source => "puppet:///modules/nagios/nagios.cfg",
	    owner => "root", group => "nagios", mode => "0644",
      require => [Package[nagios], File["/etc/httpd/conf.d/nagios.conf"]], }

   file {"/etc/nagios/cgi.cfg":
	    content => template("nagios/configs/cgi.cfg.erb"),
	    owner => "root", group => "nagios", mode => "0644",
      require => [Package[nagios], File["/etc/nagios/nagios.cfg"]], }

   file {"/etc/nagios/passwd":
	    source => "puppet:///modules/nagios/passwd",
	    owner => "root", group => "nagios", mode => "0640",
      require => [Package[nagios], File["/etc/nagios/cgi.cfg"]],}
  
   file {"/etc/nagios/private":
      ensure => directory,
	    owner => "nagios", group => "wheel", mode => "0770",}

   file {"/etc/nagios/private/resource.cfg":
	    source => "puppet:///modules/nagios/resource.cfg",
	    owner => "root", group => "nagios", mode => "0640",
      require => [Package[nagios], 
                  File["/etc/nagios/passwd"],
                  File["/etc/nagios/private"]], }

   #m badge that replaces the default notes.gif 
   file {"/usr/share/nagios/images/notes.gif":
	    source => "puppet:///modules/nagios/images/notes.gif",
	    owner => "nagios", group => "nagios", mode => "0664",
      require => Package[nagios],}

   file {"/usr/share/nagios/images/logos/centos.gif":
	    source => "puppet:///modules/nagios/vendor-logos/centos.gif",
	    owner => "nagios", group => "nagios", mode => "0664",
      require => Package[nagios],}

   file {"/usr/share/nagios/images/logos/centos.jpg":
	    source => "puppet:///modules/nagios/vendor-logos/centos.jpg",
	    owner => "nagios", group => "nagios", mode => "0664",
      require => Package[nagios],}

   file {"/usr/share/nagios/images/logos/centos.gd2":
	    source => "puppet:///modules/nagios/vendor-logos/centos.gd2",
	    owner => "nagios", group => "nagios", mode => "0664",
      require => Package[nagios],}

   file {"/usr/share/nagios/images/logos/centos.png":
	    source => "puppet:///modules/nagios/vendor-logos/centos.png",
	    owner => "nagios", group => "nagios", mode => "0664",
      require => Package[nagios],}

   file {"${naginator_patch_file}":
	    source => "puppet:///modules/nagios/naginator.rb.patch",
	    owner => "root", group => "root", mode => "0640",
      require => Package[nagios], }

   exec {"patch < naginator.rb.patch":
	    path => ["/bin", "/usr/bin", "/usr/sbin/"],
	    cwd => "/usr/lib/ruby/site_ruby/1.8/puppet/provider/",
	    subscribe => File["${naginator_patch_file}"],
	    onlyif => "/bin/false", }


   file {"/etc/nagios/hosts":
        ensure => directory,
	      owner => "nagios", group => "nagios", mode => "0777",
        require => [Package["nagios"], 
                    File["/usr/share/nagios/images/notes.gif"]], }
        
   file {"/etc/nagios/services":
        ensure => directory,
        owner => "nagios", group => "nagios", mode => "0777",
        require => [Package["nagios"], File["/etc/nagios/hosts"]], }

   file {"/var/spool/nagios/cmd/nagios.cmd":
	      owner => "nagios", group => "apache",
        require => [Package["nagios"], File["/etc/nagios/hosts"]], }
   
   exec {'find /etc/nagios/ -type f -exec chmod -R 666 {} \; -exec chown nagios:nagios {} \;':
	      path => "/bin",
	      onlyif => "/bin/false",
	      alias => "chmod_nagios", }


   service { "nagios":
         alias   => 'nagios',
         ensure  => running,
         hasstatus => true,
         hasrestart => true,
         require => [ Package[nagios], 
                      File["/etc/nagios/services"]],
         subscribe => Exec["chmod_nagios"], }

    monit::service {"nagios":
        pid_file => "/var/run/nagios.pid",
        init_script => "/etc/init.d/nagios",
        require => Package["nagios"], }
      
    #Purged unmanaged resources
    resources { "nagios_service": purge => true }
    resources { "nagios_host": purge => true }
    resources { "nagios_hostgroup": purge => true }
  
#have to define these two default nagios host 
#and hostgroup types here and onlyhere in the server.cfg 
   # collect resources and populate /etc/nagios/nagios_*.cfg
   Nagios_command <<||>> { 
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   Nagios_contact <<||>> {  
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   Nagios_contactgroups <<||>> {  
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   Nagios_host <<||>> {  
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   Nagios_hostgroup <<||>> {  
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   Nagios_service <<||>> { 
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   Nagios_servicegroup <<||>> { 
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   Nagios_timeperiod <<||>> { 
      require => Package["nagios"], notify => Exec["chmod_nagios"] }

   ##Nagios_hostextinfo <<||>> { 
      ##require => Package["nagios"], notify => Exec["chmod_nagios"] }


#default nagios definitions that the host specific 
#calls inherit from
  nagios_hostgroup { "generic-servers-group":
        hostgroup_name          => "servers",
        alias                   => "Base Servers to Monitor", }

  nagios_host { "generic-server":
    ensure => present,
    host_name => "server",
    alias => "server",
    check_command => "check_ping",
    max_check_attempts => 3,
    check_interval => 5,
    active_checks_enabled => 1,
    passive_checks_enabled => 1,
    check_period => 24x7,
    obsess_over_host => 1,
    check_freshness => 1,
    event_handler_enabled => 1,
    flap_detection_enabled => 1,
    process_perf_data => 1,
    retain_status_information => 1,
    retain_nonstatus_information => 1,
    contact_groups => it,
    notification_interval => 0,
    notification_period => notify24x7,
    notification_options => "d,u,r",
    notifications_enabled => 1,
    failure_prediction_enabled => 1,
    register =>  0,
    hostgroups => "servers", }


  nagios_service {"generic-service":
    ensure => present,
    name => "generic-service",
    service_description => "generic-service",
    host_name => "server",
    contact_groups => it,
    check_period => "24x7",
    notification_period => "notify24x7",
    notification_options => "w,u,c,r",
    normal_check_interval => 5,
    max_check_attempts => 3,
    active_checks_enabled => 1,
    passive_checks_enabled => 1,
    obsess_over_service => 1,
    check_freshness => 0,
    parallelize_check => 1,
    notifications_enabled => 1,
    event_handler_enabled => 1,
    flap_detection_enabled => 1,
    process_perf_data => 1,
    retry_check_interval => 1,
    notification_interval => 0,
    retain_status_information => 1,
    retain_nonstatus_information => 1,
    is_volatile => 0,
    failure_prediction_enabled => 1,
    register => 0, }

}#end of class nagios::server
