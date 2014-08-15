#
# Class: iptables::debug
#
# This class is used only for debugging purposes
#
# Usage:
# This class is autoloaded if you set $debug=yes
#
class iptables::debug {

    # Load the variables used in this module. Check the params.pp file 
    require iptables::params
    include puppet::debug
    include puppet::params

    file { "puppet_debug_variables_iptables":
        path    => "${puppet::params::debugdir}/variables/iptables",
        mode    => "${iptables::params::configfile_mode}",
        owner   => "${iptables::params::configfile_owner}",
        group   => "${iptables::params::configfile_group}",
        ensure  => present,
        require => File["puppet_debug_variables"],
        content => template("iptables/variables_iptables.erb"),
    }

}
