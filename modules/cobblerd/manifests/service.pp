# Class: cobblerd::service
#
# This module manages cobblerd::service
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
class cobblerd::service {
   @service {"cobblerd":
        enable  => true,
        ensure  => running,
        hasstatus => true,
        hasrestart => true, 
	tag => "cobbler_service",
        require => Class["cobblerd::config"], }

   @service {"httpd":
        enable  => true,
        ensure  => running,
        hasstatus => true,
        hasrestart => true, 
	tag => "cobbler_service",
        require => Class["cobblerd::config"], }

	Service <| tag == "cobbler_service" |>

}#end of cobblerd::service
