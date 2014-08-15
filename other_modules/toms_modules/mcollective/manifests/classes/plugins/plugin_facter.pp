class mcollective::plugin::facter inherits mcollective::plugin {

 file {"/usr/libexec/mcollective/mcollective/facts/facter_facts.rb":
	source => "puppet:///modules/mcollective/mcollective-plugins/facts/facter/facter_facts.rb",
	owner => "root", group => "root", mode => "0644",
	notify => Service["mcollective"],
	require => Package["mcollective"], }

 file {"/usr/libexec/mcollective/mcollective/facts/facter.rb":
	source => "puppet:///modules/mcollective/mcollective-plugins/facts/facter/facter.rb",
	owner => "root", group => "root", mode => "0644", 
	require => Package["mcollective"], }

}#end of mcollective::plugin::facter
