# Class: nagios::server
#
# This module manages nagios::server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class nagios::server inherits nagios {
  package {"nagios": ensure => latest }
  package {"nagios-common": ensure => latest }
  #package {"nagios-devel": ensure => latest }
  include nagios::plugins
  include nagios::pagerduty
  include nagios::contact
  include nagios::naginatorpatch

  file {"/etc/httpd/conf.d/nagios.conf":
     source => "puppet:///modules/nagios/nagios.conf",
     owner => "nagios", group => "nagios", mode => "0664", 
     require => [Package[nagios]],}

  file {"/etc/nagios/nagios.cfg":
     source => "puppet:///modules/nagios/nagios.cfg",
     owner => "nagios", group => "nagios", mode => "0660", 
     require => [Package[nagios]],}
  
  file {"/etc/nagios/htpasswd.users":
     source => "puppet:///modules/nagios/htpasswd.users",
     owner => "nagios", group => "nagios", mode => "0640", 
     require => [Package[nagios]],}

  file {"/etc/nagios/cgi.cfg":
     source => "puppet:///modules/nagios/cgi.cfg",
     owner => "nagios", group => "nagios", mode => "0660", 
     require => [Package[nagios]],}

  file {"/etc/nagios/resource.cfg":
     source => "puppet:///modules/nagios/resource.cfg",
     owner => "nagios", group => "nagios", mode => "0660", 
     require => [Package[nagios]],}

  file {"/etc/nagios/services":
    ensure => directory,
    owner => "nagios", group => "nagios", mode => "0755",
    require => Package["nagios"], }

  file {"/etc/nagios/hosts":
    ensure => directory,
    owner => "nagios", group => "nagios", mode => "0755",
    require => Package["nagios"], }

   #nagios centos images
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
    
    include nagios::service

   Nagios_command <<||>> { require => Package["nagios"] }

   Nagios_host <<||>> {  require => Package["nagios"], notify => Exec["fix_nagios_hosts"], }

   Nagios_service <<||>> { require => Package["nagios"], notify => Exec["fix_nagios_services"], }

  exec {"fix_nagios_hosts":
      command => "/bin/chown -R nagios:nagios /etc/nagios/hosts/",
      refreshonly => "true", }

  exec {"fix_nagios_services":
      command => "/bin/chown -R nagios:nagios /etc/nagios/services/",
      refreshonly => "true", }

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

}
