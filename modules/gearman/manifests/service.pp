# Class: gearman
#
# This module manages gearman
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
class gearman::service {

   service { "gearmand":
    ensure      => running,
    enable      => true,
    pattern     => "gearmand",
    hasstatus   => true,
    hasrestart  => true,
    require => Class["gearman::install"], }

}
