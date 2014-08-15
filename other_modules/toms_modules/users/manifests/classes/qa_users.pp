# Class: users::re_users
#
# Manages  users and groups
# Include it to install the qa users
#
# Usage:
# include users::re_users

class users::re_users inherits users {
	#user{"cjackson":
		#ensure => present,
		#uid => "10032",
		#gid => "10032",
		#groups => ["build-devel","logs", "release", "wheel"],
		#home => "/home/cjackson",
		#managehome => false,
		#password => '$1$s4DZnC/V\$IUKS8XjbQaq3o7D/.IgfD/',
		#shell => "/bin/bash", }

	#group{"cjackson":
		#ensure => present,
		#gid => "10032", }
		
}
