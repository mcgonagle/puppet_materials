# Class: manhunt
#
# Manages manhunt software 
# Include it to install and run manhunt with default settings
#
# Usage:
# include manhunt


import "classes/*.pp"
import "defines/*.pp"

class manhunt {
  include manhunt::params

}#end of class manhunt
