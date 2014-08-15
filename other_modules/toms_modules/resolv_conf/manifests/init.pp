# Class: resolv_conf
#
# Manages resolv_conf software 
# Include it to install and run resolv_conf with default settings
#
# Usage:
# include resolv_conf


#import "classes/*.pp"
import "defines/*.pp"

class resolv_conf {
$str = "search extlookup("searchdomains")
domain extlookup("domain")
nameserver extlookup("nameserver1")
nameserver extlookup("nameserver2")
"
    file { "/etc/resolv.conf":
        content => "${str}",
        owner => "root", group => "root", mode => "0644",}

}#end of class resolv_conf
