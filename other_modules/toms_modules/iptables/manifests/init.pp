class iptables {
 package { "iptables": ensure => latest }
 service { "iptables":
 	enable => false,
 	ensure => stopped,
	require => Package["iptables"], }
}#end of iptables
