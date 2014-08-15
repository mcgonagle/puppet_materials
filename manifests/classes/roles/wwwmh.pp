# Class: role::wwwmh
#
# This module manages role::wwwmh
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class role::wwwmh {
	class { "role::www": }
  if $zone =~ /dv/  {
    include rsync
  }#end of if
  class {"gearman": }
  class {"httpd::modules::pagespeed": }

	#include role::bbe
	#include role::mcache
	#include role::db
	#include role::dlist
  #include tomcat
  #include jotm
  #include resin
  #include resin::dev

}#end of role::wwwmh
