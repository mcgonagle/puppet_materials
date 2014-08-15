# Class: postfix
#
# Installs and manages postfix.
# Include it to install and run postfix with default settings
#
# Usage:
# include 

##import the defines and classes subdirectories
import "defines/*.pp"
import "classes/*.pp"

class postfix {
 package { "postfix": ensure => latest }
 package { "exim": ensure => absent }
 package { "sendmail ": ensure => absent }

 

}#end of postfix
