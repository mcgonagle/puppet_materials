class smartfox::memcache::populate {
 notice("The ChatArrayDaemonLR.php requires an appyml::mh, thus should be run on a www box")
 include appyml::mh_smartfox
 file{"/usr/local/manhunt/bin/ChatArrayDaemonLR.php":
	content => template("smartfox/ChatArrayDaemonLR.php.erb"),
	owner => "root", group => "root", mode => "0755", }
 
}#end of smartfox::memcache_populate
