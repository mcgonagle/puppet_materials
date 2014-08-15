class nagios::contactgroup inherits nagios {

 nagios_contactgroup{"it":
	alias			    => "IT",
	members			  => "tmcgonagle,dcote,wflynn,pagerduty" }

 nagios_contactgroup{"itdebug":
	alias			=> "IT Debugging",
	members			=> "tmcgonagle" }

}#end of nagios::contactgroup
