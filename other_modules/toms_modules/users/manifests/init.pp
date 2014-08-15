# Class: users
#
# Manages namemedia's users and groups
# Include it to install the default set of users
#
# Usage:
# include users


import "defines/*.pp"
import "classes/*.pp"

class users {
    include users::purge_users
    include users::groups
    include users::system_users


}#end of users class
