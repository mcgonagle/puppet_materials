import "classes/*.pp"

class serverdensity {
 package{"sd-agent": ensure => latest }

 file {"/etc/sd-agent/config.cfg":
	content => "[Main]
sd_url: http://mcgonagletom.serverdensity.com
agent_key: 92bcb0856974f8df8d4ecce70d3796b1",
	owner => "root", group => "root", mode => "0644",
	require => Package["sd-agent"], }

 service { "sd-agent":
 	enable => true,
 	ensure => stopped,
	subscribe => File["/etc/sd-agent/config.cfg"], }


}#end of class serverdensity
