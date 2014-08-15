define monit::monitd( 
 $pid_file = '',
 $init_script = '',
 $total_mem = '90',
 $cpu_usage = '90' ){

 $process_name = "${name}"
 $group = "system"

 file {"/etc/monit.d/${process_name}":
	content => template("monit/old_monit_d_process.erb"),
	owner => "root", group => "root", mode => "0644",
	require => Package["monit"], }
}
