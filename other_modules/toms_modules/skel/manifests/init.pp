# Class: skel
#
# Manages skel software 
# Include it to install and run skel with default settings
#
# Usage:
# include skel


import "classes/*.pp"
#import "defines/*.pp"

class skel {
    package {"rootfiles": ensure => latest }

    file {"/etc/skel":
      ensure => directory, 
      source => "puppet:///modules/skel/",
      recurse => true,
      replace => false,
      owner => "root", group => "root", mode => "0755", }

}#end of class skel
