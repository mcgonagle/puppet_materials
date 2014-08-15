class nagios::target inherits nagios {
 include nagios::nrpe

 ## Build the /etc/nagios/nagios_host.cfg file on the server    
   @@nagios_host { "$fqdn":
        ensure => present,
        alias => $hostname,
        address => $ipaddress,
        use => "linux-server",
        check_command => "check-host-alive",
        max_check_attempts => 3,
        hostgroups => "linux-servers",
        contact_groups => "it", }


 # Build nagios_service.cfg on server    
 #The following nagios_service definitions are hard coded in the /etc/nagios/nrpe.cfg
 #and thus do not accpet $ARG*$ values.
 # The following examples use hardcoded command arguments...
 #command[check_users]=/usr/lib64/nagios/plugins/check_users -w 5 -c 10
 #command[check_load]=/usr/lib64/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
 #command[check_hda1]=/usr/lib64/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda1
 #command[check_zombie_procs]=/usr/lib64/nagios/plugins/check_procs -w 5 -c 10 -s Z
 #command[check_total_procs]=/usr/lib64/nagios/plugins/check_procs -w 150 -c 200

  @@nagios_service { "check_ping_${hostname}":
       host_name => "$fqdn",
       use => "generic-service",
       service_description => "Ping",
       check_command => "check_ping", 
       require => [ Package["nagios-plugins-ping"], Nagios_command["check_ping"]] }
	
    
  @@nagios_service { "check_users_${hostname}":
       use => "generic-service",
       check_command => "check_nrpe!check_users",
       service_description => "Users",
       host_name => "$fqdn", 
       require => Package["nagios-plugins-nrpe"],}
    
 @@nagios_service { "check_load_${hostname}":
      use => "generic-service",    
      check_command => "check_nrpe!check_load",
      service_description => "Check Load",
      host_name => "$fqdn",
      require => Package["nagios-plugins-nrpe"],}
    
 @@nagios_service { "check_zombie_procs_${hostname}":
      use => "generic-service",
      check_command => "check_nrpe!check_zombie_procs",
      service_description => "Zombie Processes",
      host_name => "$fqdn", 
      require => Package["nagios-plugins-nrpe"],}
    
 @@nagios_service { "check_total_procs_${hostname}":
      use => "generic-service",
      check_command => "check_nrpe!check_total_procs",
      service_description => "Total Processes",
      host_name => "$fqdn", 
      require => Package["nagios-plugins-nrpe"],}
    
 @@nagios_service { "check_swap_${hostname}":
      use => "generic-service",
      check_command => "check_nrpe!check_swap!90%!95%",
      service_description => "Swap File",
      host_name => "$fqdn", 
      require => Package["nagios-plugins-nrpe"],}
    
 @@nagios_service { "check_all_disks_${hostname}":
      use => "generic-service",
      check_command => "check_nrpe!check_disk!20%!10%!",
      service_description => "Disk Status",
      host_name => "$fqdn", 
      require => Package["nagios-plugins-nrpe"],}
}#end of nagios::target
