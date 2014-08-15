# Class: nfs::firewall
#
# Manages nfs firewalling using custom Firewall wrapper
# By default it opens nfs's default port(s) to anybody
# It's automatically included if $firewall=yes
#
# Usage:
# Automatically included if $firewall=yes 
#
class nfs::firewall {

    include nfs::params

    firewall { "nfs_${nfs::params::protocol}_${nfs::params::port}":
        source      => "${nfs::params::firewall_source_real}",
        destination => "${nfs::params::firewall_destination_real}",
        protocol    => "${nfs::params::protocol}",
        port        => "${nfs::params::port}",
        action      => "allow",
        direction   => "input",
        enable      => "${nfs::params::firewall_enable}",
    }

}
