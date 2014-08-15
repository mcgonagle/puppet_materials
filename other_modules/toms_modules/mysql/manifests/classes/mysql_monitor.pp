class mysql::monitor {
 include nrpe
 nrpe::check{"var_lib_mysql":
   check_command => "check_disk",
   warn => "20%",
   critical => "10%",
   nrpe_parameter => "-M /var/lib/mysql", }
  
 @@nagios_service { "check_disk_var_lib_mysql ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_disk_var_lib_mysql",
   name => "check_disk_var_lib_mysql ${hostname}",
   service_description => "[mysql]check_disk /var/lib/mysql",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/index.html#disk",  
   require => [Nrpe::Check["var_lib_mysql"], 
              File["/etc/nagios/services"],
              File["/etc/nagios/nrpe.cfg"]], }

 nrpe::check{"var_log_mysql":
   check_command => "check_disk",
   warn => "20%",
   critical => "10%",
   nrpe_parameter => "-M /var/log/mysql", }
 
 @@nagios_service { "check_disk_var_log_mysql ${hostname}":
   ensure => present,
   use => "generic-service",
   host_name => "${hostname}",
   check_command => "check_nrpe!check_disk_var_log_mysql",
   name => "check_disk_var_log_mysql ${hostname}",
   service_description => "[mysql]check_disk /var/log/mysql",
   target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
   notify => Service["nagios"],
   notes => "Munin",
   notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/index.html#disk", 
   require => [Nrpe::Check["var_log_mysql"], 
              File["/etc/nagios/services"],
              File["/etc/nagios/nrpe.cfg"]], }

}#end of class mysql::monitor
