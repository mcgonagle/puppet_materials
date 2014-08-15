# Class: cron
#
# Manages cron 
# Include it to install and run cron with default settings
#
# Usage:
# include cron


import "classes/*.pp"
import "defines/*.pp"

class cron {
    #This cron_init.pp file takes the place of the old manhunt_cron_utils class
    #-Tom 10-20-10
    package {"vixie-cron": ensure => latest }

   #originally contained in the manhunt_mailif class. 
   #moved to init.pp to expose through inheritance
   cron::manhunt_cron_file{"mailif": script_name => "mailif", }
          
}#end of class cron
