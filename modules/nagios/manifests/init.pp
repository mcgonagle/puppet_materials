# Class: nagios
#
# This module manages nagios
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
class nagios {
 include nagios::plugins

 $icon_image = inline_template("<%= operatingsystem.downcase %>")

 @@nagios_host { "${hostname}":
    ensure => present,
    use => server,
    host_name => "${hostname}",
    alias => "${hostname}",
    address => "${ipaddress}",
    check_command => "check_ping",
    notes => "monit",
    notes_url => "http://${fqdn}:2812",
    icon_image => "${icon_image}.png",
    icon_image_alt => "${operatingsystem}",
    register =>  1,
    target => "/etc/nagios/hosts/${hostname}_nagios_host.cfg",
    require => File["/etc/nagios/hosts"], }

 @@nagios_service { "check_swap ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_swap",
   name => "check_swap ${hostname}",
   service_description => "[system] Swap Usage",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/swap.html", }

 @@nagios_service { "check_users ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_users",
   name => "check_users ${hostname}",
   service_description => "[system] Users Logged In",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/users.html", }

 @@nagios_service { "check_load ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_load",
   name => "check_load ${hostname}",
   service_description => "[system] Server Load",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/cpu.html", }

 @@nagios_service { "check_disk_root ${hostname}":
  ensure => present,
  use => "generic-service",
  host_name => "${hostname}",
  check_command => "check_nrpe!check_disk_root",
  name => "check_disk_root ${hostname}",
  service_description => "[system] check_disk /",
  target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
  notify => Service["nagios"],
  notes => "Munin",
  notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/index.html#disk", }

 @@nagios_service { "check_disk_opt ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_disk_opt",
   name => "check_disk_opt ${hostname}",
   service_description => "[system] check_disk /opt",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/index.html#disk", }

 @@nagios_service { "check_disk_tmp ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_disk_tmp",
   name => "check_disk_tmp ${hostname}",
   service_description => "[system] check_disk /tmp",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/index.html#disk", }

 @@nagios_service { "check_disk_var ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_disk_var",
   name => "check_disk_var ${hostname}",
   service_description => "[system] check_disk /var",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => File["/etc/nagios/services"],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/index.html#disk", }

 @@nagios_service { "check_disk_var_log ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_disk_var_log",
   name => "check_disk_var_log ${hostname}",
   service_description => "[system] check_disk /var/log",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => File["/etc/nagios/services"],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/index.html#disk", }

 @@nagios_service { "check_zombie_procs ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_zombie_procs",
   name => "check_zombie_procs ${hostname}",
   service_description => "[system] # of Zombie Procs",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => File["/etc/nagios/services"],
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/processes.html", }

 @@nagios_service { "check_total_procs ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_total_procs",
   name => "check_total_procs ${hostname}",
   service_description => "[system] # of total procs",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   require => File["/etc/nagios/services"],
   notify => Service["nagios"], 
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/processes.html", }

}
