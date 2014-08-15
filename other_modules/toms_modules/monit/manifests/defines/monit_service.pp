define monit::service(
 $group = "system",
 $pid_file,
 $init_script,
 $pattern = "" ,
 $total_mem = '90',
 $cpu_usage = '90'
){
 $process_name = "${name}"
 $template_name = extlookup("${role}::monit::${process_name}::template_name","monit_d_process.erb")

 file {"/etc/monit.d/${process_name}":
        ensure => absent, }

 file {"/etc/monit.d/monit_${process_name}":
        ensure => absent, }

 file {"/etc/monit.d/monit_${process_name}.conf":
        content => template("monit/${template_name}"),
        owner => "root", group => "root", mode => "0644",
        require => [File["/etc/monit.d/${process_name}"],
                    File["/etc/monit.d/monit_${process_name}"],
                    Package["monit"]],
	      notify => Service["monit"], }

}
