#augeas example from puppet labs:
#http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Augeas
define sysctl::conf($value) {
	#$name is provided by define invocation
	#guid of this entry
	$key = $name

	$context = "/files/etc/sysctl.conf"

	augeas { "sysctl_conf/$key":
		context => "$context",
		onlyif  => "get $key != $value",
		changes => "set $key $value",
		notify  => Exec["sysctl"],
	}
	file { "sysctl_conf":
		name => /etc/sysctl.conf", }

	exec { "sysctl -p":
		alias => "sysctl",
		refreshonly => true,
		subscribe => File["sysctl_conf"], }
}#end of sysctl::conf
