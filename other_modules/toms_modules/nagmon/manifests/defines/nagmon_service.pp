define nagmon::service(
 #monit paramters
 $group = "system",
 $pid_file = "",
 $init_script,
 $pattern = "",
 $total_mem = "90",
 $cpu_usage = "90",

 #service parameters
 $enable  = "true",
 $ensure = "running",

 #nagios notes parameters
 $notes_url = "false",
 $notes_page = "",

 #nrpe parameters
 $warn,
 $critical,
 $nrpe_parameter
){
 #include nagios and monit to expose their define scopes
 include nagios
 include monit
 include nrpe

 #template_name variable is an extlookup with a template default
 $service_name = "${name}"
 $template_name = extlookup("${role}::monit::${service_name}::template_name","monit_d_process.erb")


 #the pattern variable has additional logic built into it to 
 #determine if a pattern is defined inside monit::service
 monit::service{"${service_name}":
  pid_file => "${pid_file}",
  init_script => "${init_script}",
  pattern => "${pattern}", }

 nrpe::check{"${service_name}":
  check_command => "check_procs",
  warn => "${warn}",
  critical => "${critical}",
  nrpe_parameter => "${nrpe_parameter}", }

#can probably collapse down the notes_url logic 
if $notes_url != "false" {
 @@nagios_service { "check_procs_${service_name} ${hostname}":
  name => "check_procs_${service_name} ${hostname}",
  ensure => present,
  use => "generic-service",
  host_name => "${hostname}",
  check_command => "check_nrpe!check_procs_${service_name}",
  service_description => "check_procs_${service_name}",
  target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  require => [File["/etc/nagios/services"],
              Nrpe::Nrpe_check["${service_name}"]],
  notes => "Munin",
  notes_url => "http://${fqdn}/munin/${domain}/${fqdn}/${notes_page}", 
  notify => Service["nagios"], }
} else {
 @@nagios_service { "check_procs_${service_name} ${hostname}":
  name => "check_procs_${service_name} ${hostname}",
  ensure => present,
  use => "generic-service",
  host_name => "${hostname}",
  check_command => "check_nrpe!check_procs_${service_name}",
  service_description => "[system-procs]check_procs_${service_name}",
  target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
  require => [File["/etc/nagios/services"],
              Nrpe::Check["check_proc_${service_name}"]],
  notify => Service["nagios"], }
}#end of if else

 service { "${service_name}":
        enable => "${enable}",
        ensure => "${ensure}", }
}#end of define
