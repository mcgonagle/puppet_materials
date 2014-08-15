# Class: openfire
#
# Manages openfire software 
# Include it to install and run openfire with default settings
#
# Usage:
# include openfire


#import "classes/*.pp"
#import "defines/*.pp"

class openfire {
  package { "openfire": ensure => latest, }

}#end of class openfire
