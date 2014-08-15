# Class: splunk
#
# Manages splunk software 
# Include it to install and run splunk with default settings
#
# Usage:
# include splunk
#downloading the splunk rpm 
#wget 'http://www.splunk.com/index.php/download_track?file=4.1.6/linux/splunk-4.1.6-89596-linux-2.6-x86_64.rpm&ac=&wget=true&name=wget&typed=releases'

import "classes/*.pp"
#import "defines/*.pp"

class splunk {
    include users::it_users
    $splunk_indexer = "${servername}"
    
    package { "splunk": ensure => latest,
      require => Class["users::it_users"],  }

    file {"/etc/init.d/splunk":
      source => "puppet:///modules/splunk/splunk",
      owner => "root", group => "root", mode => "0700",
      before => Service["splunk"], }

    file { "/opt/splunk/etc/apps/search/local":
      ensure => directory,
      owner => "splunk", group => "splunk", mode => "0755",
      require => Package["splunk"],
      before => [ File["splunk_outputs.conf"], File["splunk_inputs.conf"] ], }

    file { "/opt/splunk/etc/apps/search/local/outputs.conf":
      alias => "splunk_outputs.conf",
      content => template("splunk/outputs.conf.erb"),
      owner => "splunk", group => "splunk", mode => "0600", 
      before => Service["splunk"], }

    file { "/opt/splunk/etc/apps/search/local/inputs.conf":
      alias => "splunk_inputs.conf",
      #source => [ "puppet:///modules/splunk/inputs/inputs.conf.${hostname}",
                  #"puppet:///modules/splunk/inputs/inputs.conf.${role}",
                  #"puppet:///modules/splunk/inputs/inputs.conf" ],
      content => template("splunk/inputs/${role}.inputs.conf.erb"),
      owner => "splunk", group => "splunk", mode => "0600", 
      before => Service["splunk"], }

    file{"/opt/splunk/etc/splunk.license":
	source => "puppet:///modules/splunk/splunk-free.license",
	owner => "splunk", group => "splunk", mode => "0600",
	notify => Service["splunk"], 
	require => Package["splunk"], }

    service { "splunk":
      enable => true, 
      ensure => running, }
    
   #monitor splunk
    monit::monitd{"splunk":
        pid_file => "/opt/splunk/var/run/splunk/splunkd.pid",
        init_script => "/etc/init.d/splunk", }

    monit::monitd{"splunkweb":
        pid_file => "/opt/splunk/var/run/splunk/splunkd..pid",
        init_script => "/etc/init.d/splunk", }

   @@nagios_service { "check_splunkd_proc ${hostname}":
    ensure => present,
    use => "generic-service",
    host_name => "${hostname}",
    check_command => "check_nrpe!check_splunkd_proc",
    name => "check_splunkd_proc ${hostname}",
    service_description => "check_splunkd_proc",
    target => "/etc/nagios/services/${hostname}_nagios_services.cfg",
    require => [File["/etc/nagios/services"],File["/etc/nagios/nrpe.cfg"]],
    notify => Service["nagios"], }  

}#end of class splunk
