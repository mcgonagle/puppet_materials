# Class: dovecot::firewall
#
# Manages dovecot firewalling using custom Firewall wrapper
# By default it opens dovecot's default port(s) to anybody
# It's automatically included if $firewall=yes
#
# Usage:
# Automatically included if $firewall=yes 
#
class dovecot::firewall {

    include dovecot::params

    firewall { "dovecot_${dovecot::params::protocol}_${dovecot::params::port}":
        source      => "${dovecot::params::firewall_source_real}",
        destination => "${dovecot::params::firewall_destination_real}",
        protocol    => "${dovecot::params::protocol}",
        port        => "${dovecot::params::port}",
        action      => "allow",
        direction   => "input",
        enable      => "${dovecot::params::firewall_enable}",
    }

}
