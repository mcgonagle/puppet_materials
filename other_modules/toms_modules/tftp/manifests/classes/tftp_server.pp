class tftp::server inherits tftp {
 package{"tftp-server":ensure => latest}
 file{"/etc/xinetd.d/tftp":
	source => "puppet:///modules/tftp/tftp",
	owner => "root", group => "root", mode => "0644", 
	require => Package["tftp-server"], }
	
}#end of class tftp::server
