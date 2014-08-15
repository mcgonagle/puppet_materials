# Class: limits
#
# Manages limits software 
# Include it to install and run limits with default settings
#
# Usage:
# include limits


import "defines/*.pp"

class limits {
    limits::conf {"${name}":
	#maximum number of open files/sockets for root
	"root-soft": domain => "root", type => soft, item => nofile, value => 9999;
	"root-hard": domain => "root", type => soft, item => nofile, value => 9999;
	#maximum number of open files/sockets for all default users
	"wildcard-all": domain => "*", type => "-", item => nofile, value => 8096;
    }

}#end of class limits
