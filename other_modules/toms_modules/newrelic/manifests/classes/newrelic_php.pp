class newrelic::php {
 package { "newrelic-php5": ensure => latest }
 file {"/etc/newrelic/newrelic.cfg":
	source => "puppet:///modules/newrelic/newrelic.cfg",
	owner => "root", group => "root", mode => "0755",
	notify => Service["newrelic-daemon"], }

 service{"newrelic-daemon": ensure => latest }

  

}#end of class newrelic::php
