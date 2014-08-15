# Class: users::au_users
#
# Manages  users and groups
# Include it to install the qa users
#
# Usage:
# include users::au_users

class users::au_users inherits users {
  user{"sopalenski":
                ensure => present,
		            comment => "Steve Opalenski",
                uid => "10033",
                gid => "10033",
                groups => ["build-devel","logs", "release", "wheel"],
                home => "/home/sopalenski",
                managehome => false,
		            password => '$1$ZXkrdcoB$iy01oMSdG3ZiEmLqEibIE/',
                shell => "/bin/bash", }

   group{"sopalenski":
                ensure => present,
                gid => "10033", }
}#end of users::re_user
