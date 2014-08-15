class mcollective::plugin::service inherits mcollective::plugin {
 file {"/usr/libexec/mcollective/mcollective/agent/service.rb":
	source => "puppet:///modules/mcollective/mcollective-plugins/agent/service/puppet-service.rb",
	owner => "root", group => "root", mode => "0644", 
	require => Package["mcollective"], }

 file {"/usr/libexec/mcollective/mcollective/agent/service.ddl":
	source => "puppet:///modules/mcollective/mcollective-plugins/agent/service/service.ddl",
	owner => "root", group => "root", mode => "0644", 
	require => Package["mcollective"], }

 file {"/usr/sbin/mc-service":
	source => "puppet:///modules/mcollective/mcollective-plugins/agent/service/mc-service",
	owner => "root", group => "root", mode => "0755", 
	require => Package["mcollective"], }

}#end of mcollective::plugin::service
