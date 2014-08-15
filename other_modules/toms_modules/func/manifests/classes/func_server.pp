class func::server inherits func {
 file{"/etc/certmaster/certmaster.conf":
	content => template("func/server/certmaster.conf.erb"),
	owner => "root", group => "root", mode => "0644",
        notify => Service["certmaster"], }
}#end of func::server
