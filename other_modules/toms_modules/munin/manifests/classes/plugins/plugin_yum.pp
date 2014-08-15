class munin::plugin::yum inherits munin::plugin {
 file{"/var/lib/munin/plugin-state/yum.state":
	ensure => present,
	owner => "munin", group => "munin", mode => "0664", }


}#end of class munin::plugin::yum
