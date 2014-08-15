define nrpe::check(
	$check_command,
	$warn,
	$critical,
	$nrpe_parameter
) {
 $check_command_name = "${check_command}"
 $service_name = "${name}"
 $warning_alert = "${warn}"
 $critical_alert = "${critical}"
 $nrpe_param = "${nrpe_parameter}"
 
 $template_name = extlookup("${role}::nrpe::${name}::template_name", "nrpe.d_check.erb")

  file{"/etc/nagios/nrpe.d/${check_command}_${service_name}.cfg":
	  content => template("nrpe/nrpe.d/${template_name}"),
	  owner => "nagios", group => "nagios", mode => "0644",
    notify => Service["nrpe"], }
}#end of nrpe::nrpe_check
