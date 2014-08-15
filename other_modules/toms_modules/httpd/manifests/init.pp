import "classes/*.pp"

class httpd {
  package{"httpd": ensure => latest }

  file{"/etc/httpd/conf/httpd.conf":
	  content => template("httpd/httpd.conf.erb"),
	  owner => "root", group => "root", mode => "0644",
	  require => Package["httpd"], }

  file{"/var/log/httpd":
	  ensure => directory,
	  owner => "root", group => "root", mode => "0755",
	  require => [Package["httpd"], 
               File["/etc/httpd/conf/httpd.conf"]], }

  #will probably have to update the httpd, nagmon::service
  #define. I want to tie it to ram on a server
  nagmon::service {"httpd":
	  ensure => running,
	  enable => true, 
    pid_file => "/var/run/httpd.pid",
    init_script => "/etc/init.d/httpd",
    warn => "1:",
    critical => "1:1024",
    nrpe_parameter => "-C httpd",  
	  require => [Package["httpd"],
                File["/etc/httpd/conf/httpd.conf"],
                File["/var/log/httpd"]],
	  subscribe => File["/etc/httpd/conf/httpd.conf"], }

}#end of class httpd
