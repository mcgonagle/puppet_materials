# Define: bind::zone
#
# Adds a custom bind zone to named.conf
# The $file params defines the name of the zone file in named.conf
# The $file_source defines where to retrive via the zone file (prefix puppet:/// is implied)
#     It empty the zone file is not provided via bind::zone
#
# Usage examples:
#
# For a Master zone (zone file is called example42.com):
# bind::zone { "example42.com": }
#
# For a Master zone (zone file is called db.example42.com):
# bind::zone { "example42.com": file => "db.example42.com" }
#
# For a Slave zone (masters variable required):
# bind::zone { "example42.com": zone_type => "slave" , masters  => "10.42.42.5" }
#
# For a Forward zone (for more than one forwarders use an array):
# bind::zone { "example42.com": zone_type => "forward" , forwarders  => [ "10.42.42.5" , "10.42.42.6" ] }
#
define bind::zone (
    $zone_type="master",
    $file="",
    $file_source="",
    $masters="",
    $forwarders="",
    $allow_query="",
    $allow_transfer="",
    $also_notify="",
    $enable="yes" ) {

    include bind::params
    include concat::setup

    $true_file = $file ? {
        ''      => $name,
        default => $file,
    }

    $ensure = $enable ? {
        "false" => "absent",
        "no"    => "absent",
        "true"  => "present",
        "yes"   => "present",
    }

    concat::fragment{ "named_conf_zone_$name":
        target  => "${bind::params::configfile}",
        content => template("bind/concat/named.conf_zone.erb"),
        order   => 15,
        ensure  => $ensure,
        notify  => Service["bind"],
    }

    if ( $zone_type == "master" and $file_source != "" ) {
        file { "zone_$name":
            path    => "${bind::params::datadir}/${true_file}",
            mode    => "644",
            owner   => "root",
            group   => "${bind::params::user}",
            ensure  => present,
            source  => "puppet:///${file_source}",
        }
    }
}
